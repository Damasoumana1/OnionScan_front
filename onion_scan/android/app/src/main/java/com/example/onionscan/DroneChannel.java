package com.example.onionscan;

import android.content.Context;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import dji.common.error.DJIError;
import dji.common.error.DJISDKError;
import dji.sdk.base.BaseProduct;
import dji.sdk.base.BaseComponent;
import dji.sdk.products.Aircraft;
import dji.sdk.sdkmanager.DJISDKManager;
import dji.sdk.sdkmanager.DJISDKInitEvent;

public class DroneChannel implements FlutterPlugin, MethodChannel.MethodCallHandler {
    private MethodChannel channel;
    private Context context;

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        if (flutterPluginBinding == null) {
            return; // Évite une exception si le binding est null
        }
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.onionscan/dji");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (context == null) {
            result.error("CONTEXT_NULL", "Application context is null", null);
            return;
        }

        if (call.method.equals("initializeSDK")) {
            if (DJISDKManager.getInstance() == null) {
                result.error("SDK_NULL", "DJISDKManager is not initialized", null);
                return;
            }
            DJISDKManager.getInstance().registerApp(context, new DJISDKManager.SDKManagerCallback() {
                @Override
                public void onRegister(DJIError djiError) {
                    if (djiError == DJISDKError.REGISTRATION_SUCCESS) {
                        DJISDKManager.getInstance().startConnectionToProduct();
                        result.success(true);
                    } else {
                        result.success(false); // Échec d'enregistrement
                    }
                }

                @Override
                public void onProductDisconnect() {
                    if (channel != null) {
                        channel.invokeMethod("onProductDisconnect", null);
                    }
                }

                @Override
                public void onProductConnect(BaseProduct product) {
                    if (channel != null) {
                        channel.invokeMethod("onProductConnect", null);
                    }
                }

                @Override
                public void onProductChanged(BaseProduct product) {}

                @Override
                public void onComponentChange(BaseProduct.ComponentKey key, BaseComponent oldComponent, BaseComponent newComponent) {}

                @Override
                public void onDatabaseDownloadProgress(long current, long total) {}

                @Override
                public void onInitProcess(DJISDKInitEvent event, int totalProcess) {}
            });
        } else if (call.method.equals("connectDrone")) {
            BaseProduct product = DJISDKManager.getInstance().getProduct();
            if (product != null && product instanceof Aircraft) {
                result.success(product.isConnected());
            } else {
                result.success(false);
            }
        } else if (call.method.equals("disconnectDrone")) {
            result.success(true);
        } else if (call.method.equals("testConnection")) {
            BaseProduct product = DJISDKManager.getInstance().getProduct();
            result.success(product != null && product.isConnected());
        } else if (call.method.equals("getFirmwareVersion")) {
            BaseProduct product = DJISDKManager.getInstance().getProduct();
            if (product != null && product.isConnected() && product instanceof Aircraft) {
                Aircraft aircraft = (Aircraft) product;
                String firmwareVersion = aircraft.getFirmwarePackageVersion();
                result.success(firmwareVersion != null ? firmwareVersion : "Unknown");
            } else {
                result.success("Unknown");
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
    }
}