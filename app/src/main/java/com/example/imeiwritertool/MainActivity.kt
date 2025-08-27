package com.example.imeiwritertool

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.telephony.TelephonyManager
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import java.io.File
import java.io.FileOutputStream

class MainActivity : AppCompatActivity() {

    private val REQUEST_PERMISSIONS = 100

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (hasPermissions()) {
            writeImeiToFile()
        } else {
            requestPermissions()
        }
    }

    private fun hasPermissions(): Boolean {
        val phonePermission = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE)
        val storagePermission = ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
        return phonePermission == PackageManager.PERMISSION_GRANTED &&
                storagePermission == PackageManager.PERMISSION_GRANTED
    }

    private fun requestPermissions() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE
            ),
            REQUEST_PERMISSIONS
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_PERMISSIONS) {
            if (grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
                writeImeiToFile()
            } else {
                Toast.makeText(this, "مجوزها ضروری هستند.", Toast.LENGTH_LONG).show()
                finish()
            }
        }
    }

    private fun writeImeiToFile() {
        val telephonyManager = getSystemService(TELEPHONY_SERVICE) as TelephonyManager
        val imei = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            telephonyManager.imei
        } else {
            @Suppress("DEPRECATION")
            telephonyManager.deviceId
        }

        val file = File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS), "imei.txt")

        try {
            FileOutputStream(file).use { stream ->
                stream.write(imei.toByteArray())
            }
            Toast.makeText(this, "IMEI ذخیره شد: ${file.absolutePath}", Toast.LENGTH_LONG).show()
        } catch (e: Exception) {
            Toast.makeText(this, "خطا: ${e.message}", Toast.LENGTH_LONG).show()
        }

        finish()
    }
}
