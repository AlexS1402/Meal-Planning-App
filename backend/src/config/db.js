const mysql = require('mysql2');
const fs = require('fs');

// Create a database connection and export it
const db = mysql.createConnection({
    host: 'meal-planner-db.mysql.database.azure.com',
    user: 'root_admin',
    password: '36ZUzXR5287i',
    database: 'meal_planning_app',
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
