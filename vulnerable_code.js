const express = require('express');
const bodyParser = require('body-parser');
const sqlite3 = require('sqlite3').verbose();
const app = express();
const db = new sqlite3.Database(':memory:');

app.use(bodyParser.urlencoded({ extended: true }));

// Insecure endpoint: SQL Injection
app.post('/login', (req, res) => {
  const username = req.body.username;
  const password = req.body.password;
  const query = `SELECT * FROM users WHERE username = '${username}' AND password = '${password}'`;
  db.get(query, (err, row) => {
    if (err) {
      res.status(500).send('Internal server error');
    } else if (row) {
      res.send('Login successful');
    } else {
      res.status(401).send('Unauthorized');
    }
  });
});

// Insecure endpoint: XSS
app.get('/search', (req, res) => {
  const searchQuery = req.query.q;
  res.send(`<h1>Search results for: ${searchQuery}</h1>`);
});

// Insecure endpoint: No Authentication
app.get('/admin', (req, res) => {
  res.send('Welcome to the admin panel');
});

// Insecure endpoint: Sensitive Data Exposure
app.get('/user/:id', (req, res) => {
  const userId = req.params.id;
  db.get(`SELECT * FROM users WHERE id = ${userId}`, (err, row) => {
    if (err) {
      res.status(500).send('Internal server error');
    } else if (row) {
      res.json(row);
    } else {
      res.status(404).send('User not found');
    }
  });
});

// Insecure endpoint: CSRF
app.post('/update-profile', (req, res) => {
  const userId = req.body.id;
  const newProfileData = req.body.profile;
  db.run(`UPDATE users SET profile = '${newProfileData}' WHERE id = ${userId}`, (err) => {
    if (err) {
      res.status(500).send('Internal server error');
    } else {
      res.send('Profile updated');
    }
  });
});

// Initialize the database
db.serialize(() => {
  db.run("CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT, profile TEXT)");
  db.run("INSERT INTO users (username, password, profile) VALUES ('admin', 'password', 'Admin profile')");
});

app.listen(3000, () => {
  console.log('App running on port 3000');
});
