const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const db = mysql.createConnection({
    host: 'meal-planner-db.mysql.database.azure.com',
    user: 'root_admin',
    password: '36ZUzXR5287i',
    database: 'meal-planner-db',
});

db.connect(err => {
    if (err) {
        return console.error('error connecting: ' + err.message);
    }
    console.log('connected to the MySQL server.');
});

app.get('/api/test', (req, res) => {
    db.query('SELECT 1 + 1 AS solution', (error, results, fields) => {
        if (error) throw error;
        res.send(`The solution is: ${results[0].solution}`);
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}.`);
});
