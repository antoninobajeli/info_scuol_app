package com.bajeli.infoscuolapp

import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.view.FlutterView
import android.content.Context
import android.content.Intent
import android.view.WindowManager.LayoutParams
import io.flutter.plugin.common.StringCodec
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.BasicMessageChannel



import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import com.bajeli.infoscuolapp.BuildConfig;






class MainActivity(): FlutterActivity()  {
    private val CHANNEL = "deeplink.channel/registration"

    private val CHANNEL2 = "getVersionChannel"

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val verifyToken = getVerifyToken(intent)
        if(verifyToken!=""){
            val view = getFlutterView()
            val deepLinkChannel = MethodChannel(view, CHANNEL)
            val parmamsMap = HashMap<String, String>()
            parmamsMap.put("verifyToken", verifyToken)

            android.util.Log.d("onNewIntent >> Calling deepLinkChannel with param:", parmamsMap.get("verifyToken"))
            deepLinkChannel.invokeMethod("autoRegistrationLogin",parmamsMap)
        }
    }






    override fun onResume() {
        super.onResume()
        /*val verifyToken = getVerifyToken(getIntent())
        if(verifyToken!=""){
            val view = getFlutterView()
            val deepLinkChannel = MethodChannel(view, CHANNEL)
            val parmamsMap = HashMap<String, String>()
            parmamsMap.put("verifyToken", verifyToken)

            android.util.Log.d("onResume >> Calling deepLinkChannel with param:", parmamsMap.get("verifyToken"))
            deepLinkChannel.invokeMethod("autoRegistrationLogin",parmamsMap)
        }*/

    }

    override fun onPostCreate(savedInstanceState: Bundle?) {
        super.onPostCreate(savedInstanceState)

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)


        MethodChannel(getFlutterView(), CHANNEL2).setMethodCallHandler { call, result ->
            android.util.Log.d("BuildConfig.VERSION_NAME","BuildConfig.VERSION_NAME ${BuildConfig.VERSION_NAME}")
            if (call.method.equals("getPlatformVersion")) {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            } else if (call.method.equals("getAppVersionName")) {
                result.success("vname ${BuildConfig.VERSION_NAME}")
            } else if (call.method.equals("getAppCodeName")) {
                result.success("vcode ${BuildConfig.VERSION_CODE}")
            } else if (call.method.equals("getAppID")) {
                result.success("id ${BuildConfig.APPLICATION_ID}")
            } else{
                result.notImplemented()
            }
        }




        /*val urlAndParmams = getUrlAndPatam()
        android.util.Log.d("onCreate", "onCreate")
        val fooChannel = BasicMessageChannel(view, CHANNEL, StringCodec.INSTANCE)
        android.util.Log.d("Calling fooChannel with param:", route)
        fooChannel.send(route)*/

/*
        val verifyToken = getVerifyToken()
        if(verifyToken!=""){
            val view = getFlutterView()
            val deepLinkChannel = MethodChannel(view, CHANNEL)
            val parmamsMap = HashMap<String, String>()
            parmamsMap.put("verifyToken", verifyToken)

            android.util.Log.d("Calling deepLinkChannel with param:", parmamsMap.get("verifyToken"))
            deepLinkChannel.invokeMethod("autoRegistrationLogin",parmamsMap)
        }*/

    }



    /*
    * gestione deep link
    *
    * db shell am start -W -a android.intent.action.VIEW -d "http://com.bajeli.infoscuolapp/invite" com.bajeli.infoscuolapp
    * */

    override fun createFlutterView(context: Context): FlutterView {
        val view = FlutterView(this)
        view.setLayoutParams(LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))
        setContentView(view)
        val verifyToken = getVerifyToken(getIntent())
        /*if(verifyToken!=""){
            val deepLinkChannel = MethodChannel(view, CHANNEL)
            val parmamsMap = HashMap<String, String>()
            parmamsMap.put("verifyToken", verifyToken)

            android.util.Log.d("createFlutterView >> Calling deepLinkChannel with param:", parmamsMap.get("verifyToken"))
            deepLinkChannel.invokeMethod("autoRegistrationLogin",parmamsMap)
        }*/

        if (verifyToken != "") {
            /*val deepLinkChannel = MethodChannel(view, CHANNEL)
            android.util.Log.d("createFlutterView >> Calling deepLinkChannel with param:", verifyToken)
            deepLinkChannel.invokeMethod("openURL",verifyToken)
            */
            val route="/?verifyToken="+verifyToken
            android.util.Log.d("ROUTE", route)
            view.setInitialRoute(route)
        }
        return view
    }


    private fun getRouteFromIntent(): String {
        val intent = getIntent()
        if (Intent.ACTION_VIEW.equals(intent.getAction()) && intent.getData() != null) {
            if (intent.getData().getQueryParameter("verifyToken") != null){
                return intent.getData().getPath()+"?verifyToken="+intent.getData().getQueryParameter("verifyToken")
            }

            return intent.getData().getPath()
        }
        return "/"
    }


    private fun getVerifyToken(intent :android.content.Intent): String {

        //android.util.Log.d("Calling getVerifyToken","Calling getVerifyToken");
        //if (Intent.ACTION_VIEW.equals(intent.getAction()) && intent.getData() != null) {
        if (  intent.getData() != null) {
            if (intent.getData().getQueryParameter("verifyToken") != null){
                return intent.getData().getQueryParameter("verifyToken");
                //return intent.getData().getPath()+"?verifyToken="+intent.getData().getQueryParameter("verifyToken")
            }
            //android.util.Log.d("NO verifyToken","NO verifyToken");
            return intent.getData().getPath();
        }
        //android.util.Log.d("NO intent.getAction","NO intent.getAction");
        return "";
    }




}