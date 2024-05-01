require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const db = require('./db');
const passport = require('passport');
const session = require('express-session');
const GoogleStrategy = require('passport-google-oauth20').Strategy;

passport.use(new GoogleStrategy({
    clientID: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: "/auth/google/redirect"
}, (accessToken, refreshToken, profile, done) => {
    console.log('Google profile', profile);
    done(null, profile);
}));

// Initialize express app
const app = express();

// Use middleware
app.use(cors());
app.use(bodyParser.json());

// Session middleware setup
app.use(session({
    secret: 'your-secret-key',  // Replace 'your-secret-key' with a real secret string
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false, maxAge: 1000 * 60 * 60 * 24 }  // For HTTP; set secure: true if you're using HTTPS
}));

// Initialize Passport and restore authentication state, if any, from the session.
app.use(passport.initialize());
app.use(passport.session());

// Define routes
app.get('/', (req, res) => {
    res.send('Hello from the backend API!');
});

// Passport's Google OAuth routes
app.get('/auth/google', passport.authenticate('google', {
    scope: ['profile']  // Adjust scope based on the data you need (e.g., 'email')
}));

app.get('/auth/google/redirect', passport.authenticate('google'), (req, res) => {
    res.redirect('/profile/');  // Redirect to a profile page or home
});

// Import and use the routes for recipes
const recipesRoutes = require('./routes/recipes_be');  // Adjust the path as necessary
app.use('/recipes', recipesRoutes);

// Define a port and start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
