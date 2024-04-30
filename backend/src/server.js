const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const db = require('./db');
const router = express.Router();
const recipesRoutes = require('./routes/recipes_be');

// Initialize express app
const app = express();

// Use middleware
app.use(cors());
app.use(bodyParser.json());

// Define routes
app.get('/', (req, res) => {
    res.send('Hello from the backend API!');
});

//use the recipesRoutes
app.use('/recipes', recipesRoutes);

// Define a port and start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
