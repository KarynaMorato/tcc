package com.example.projetointegrado

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle

class FormLogin : AppCompatActivity() {

    private TextView text_tela_cadastro;

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_form_login)

        supportActionBar.hide();

        text_tela_cadastro.SetOnClickListener()
    }

    private void IniciarComponentes(){
        text_tela_cadastro = findViewById(R.id.text_tela_cadastro);

    }
}