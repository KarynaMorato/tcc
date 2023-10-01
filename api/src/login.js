const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');

const app = express();

// Configuração do banco de dados
const db = mysql.createConnection({
  host: 'db',
  user: 'sqluser',
  password: 'password',
  database: 'GestaoObra',
});

db.connect((err) => {
  if (err) {
    console.log (err)
  }
  else
  {
      console.log ('conectado com sucesso');
      app.listen(3000, function() {
        console.log('Example app listening on port 3000!');
    });
  }
});

// Middleware para análise de solicitações JSON
app.use(bodyParser.json());

app.get('/cliente/:CodCliente', (req, res) => {
    try {
      const { CodCliente } = req.params;
    const sql = 'CALL LerClientePorCodigo(?)';
    db.query(sql, [CodCliente], (err, result) => {
      if (err) throw err;
      res.json({ result });
    });
    } catch (error) {
      console.log(error);
    }
    
  });

