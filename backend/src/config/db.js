const mysql = require('mysql2');
const fs = require('fs');
require('dotenv').config();

// Create a database connection and export it
const db = mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: {
        ca: fs.readFileSync('DigiCertGlobalRootCA.crt.pem')
      }
});

db.connect(err => {
    //console.log(db);
    if (err) {
        console.error('Error connecting to the database:', err);
        process.exit(1);  // Exit in case of database connection error
    }
    console.log('Connected to the database successfully.');
});

module.exports = db;