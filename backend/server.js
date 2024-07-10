// Import required modules
const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const mysql = require('mysql');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

const SECRET_KEY = 'mT80w2HIIS';

// Connect to MySQL
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  database: 'matnetdb'
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL: ' + err.stack);
    return;
  }
  console.log('Connected to MySQL as id ' + connection.threadId);
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));  // Add this line

const authenticateJWT = (req, res, next) => {
  const token = req.header('Authorization');
  if (token) {
    jwt.verify(token, SECRET_KEY, (err, user) => {
      if (err) {
        return res.sendStatus(403);
      }
      req.user = user;
      next();
    });
  } else {
    res.sendStatus(401);
  }
};
//DRIVERS
app.post('/api/register_driver', async (req, res) => {
  const { name, phone, licenseId, password } = req.body;

  // Log the request parameters for debugging
  console.log('Received parameters:', { name, phone, licenseId, password });

  if (!name || !phone || !licenseId || !password) {
    res.status(400).send('All fields are required');
    return;
  }

  try {
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 100);
    console.log('Hashed password:', hashedPassword);

    const query = 'INSERT INTO drivers (name, phone, licenseId, password) VALUES (?, ?, ?, ?)';

    connection.query(query, [name, phone, licenseId, hashedPassword], (err, result) => {
      if (err) {
        console.error('Database insert error:', err);
        res.status(500).send('Server error');
      } else {
        res.status(200).send('Driver registered successfully');
      }
    });
  } catch (error) {
    console.error('Error hashing password:', error);
    res.status(500).send('Server error');
  }
});

app.post('/api/login_driver', (req, res) => {
  const { name, password } = req.body;

  if (!name || !password) {
    res.status(400).send('All fields are required');
    return;
  }

  const query = 'SELECT * FROM drivers WHERE name = ?';
  connection.query(query, [name], (err, results) => {
    if (err) {
      console.error('Error logging in: ' + err.stack);
      res.status(500).send('Error logging in');
      return;
    }
    if (results.length === 0) {
      res.status(404).send('Driver not found');
      return;
    }
    const driver = results[0];
    const passwordIsValid = bcrypt.compareSync(password, driver.password);
    if (!passwordIsValid) {
      res.status(401).send('Invalid password');
      return;
    }
    const token = jwt.sign({ id: driver.id }, SECRET_KEY, { expiresIn: '24h' });
    res.status(200).json({ token });
  });
});


//COMMUTERS
app.post('/api/register_commuter', async (req, res) => {
  const { name, phone, password } = req.body;

  // Log the request parameters for debugging
  console.log('Received parameters:', { name, phone, password });

  if (!name || !phone || !password) {
    res.status(400).send('All fields are required');
    return;
  }

  try {
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 100);
    console.log('Hashed password:', hashedPassword);

    const query = 'INSERT INTO commuters (name, phone, password) VALUES (?, ?, ?)';

    connection.query(query, [name, phone, hashedPassword], (err, result) => {
      if (err) {
        console.error('Database insert error:', err);
        res.status(500).send('Server error');
      } else {
        res.status(200).send('Commuter registered successfully');
      }
    });
  } catch (error) {
    console.error('Error hashing password:', error);
    res.status(500).send('Server error');
  }
});

app.post('/api/login_commuter', (req, res) => {
  const { name, password } = req.body;

  if (!name || !password) {
    res.status(400).send('All fields are required');
    return;
  }

  const query = 'SELECT * FROM commuters WHERE name = ?';
  connection.query(query, [name], (err, results) => {
    if (err) {
      console.error('Error logging in: ' + err.stack);
      res.status(500).send('Error logging in');
      return;
    }
    if (results.length === 0) {
      res.status(404).send('commuter not found');
      return;
    }
    const commuter = results[0];
    const passwordIsValid = bcrypt.compareSync(password, commuter.password);
    if (!passwordIsValid) {
      res.status(401).send('Invalid password');
      return;
    }
    const token = jwt.sign({ id: commuter.id }, SECRET_KEY, { expiresIn: '24h' });
    res.status(200).json({ token });
  });
});

//SACCOS
app.post('/api/register_sacco', async (req, res) => {
  const { name, password } = req.body;

  // Log the request parameters for debugging
  console.log('Received parameters:', { name, password });

  if (!name || !password) {
    res.status(400).send('All fields are required');
    return;
  }

  try {
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 100);
    console.log('Hashed password:', hashedPassword);

    const query = 'INSERT INTO sacco (name, password) VALUES (?, ?)';

    connection.query(query, [name, hashedPassword], (err, result) => {
      if (err) {
        console.error('Database insert error:', err);
        res.status(500).send('Server error');
      } else {
        res.status(200).send('Sacco registered successfully');
      }
    });
  } catch (error) {
    console.error('Error hashing password:', error);
    res.status(500).send('Server error');
  }
});

app.post('/api/login_sacco', (req, res) => {
  const { name, password } = req.body;

  console.log('Login request received:', { name, password });

  if (!name || !password) {
    res.status(400).send('All fields are required');
    return;
  }

  const query = 'SELECT * FROM sacco WHERE name = ?';
  connection.query(query, [name], (err, results) => {
    if (err) {
      console.error('Error querying database:', err);
      res.status(500).send('Error logging in');
      return;
    }
    if (results.length === 0) {
      res.status(404).send('Sacco not found');
      return;
    }
    const sacco = results[0];
    const passwordIsValid = bcrypt.compareSync(password, sacco.password);
    if (!passwordIsValid) {
      res.status(401).send('Invalid password');
      return;
    }
    const token = jwt.sign({ id: sacco.id }, SECRET_KEY, { expiresIn: '1h' });
    res.status(200).json({ token });
  });
});



app.get('/api/saccos', (req, res) => {
  const query = 'SELECT id, name FROM sacco';
  connection.query(query, (err, results) => {
    if (err) {
      console.error('Error fetching saccos: ' + err.stack);
      res.status(500).send('Server error');
      return;
    }
    res.status(200).json(results);
  });
});

//VEHICLES
app.post('/api/register_vehicle', authenticateJWT, (req, res) => {
  const { licensePlate, stagePoints, destinations, saccoId } = req.body;
  const driverId = req.user.id;

  if (!licensePlate || !stagePoints || !destinations || !saccoId) {
    res.status(400).send('All fields are required');
    return;
  }

  const query = 'INSERT INTO vehicles (driverId, licensePlate, stagePoints, destinations, saccoId) VALUES (?, ?, ?, ?, ?)';
  connection.query(query, [driverId, licensePlate, JSON.stringify(stagePoints), JSON.stringify(destinations), saccoId], (err, result) => {
    if (err) {
      console.error('Database insert error:', err);
      res.status(500).send('Server error');
    } else {
      res.status(200).send('Vehicle registered successfully');
    }
  });
});


app.get('/api/protected', authenticateJWT, (req, res) => {
  res.status(200).send('Protected content');
});

io.on('connection', (socket) => {
  console.log('New client connected');
  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });
});

server.listen(3000, () => {
  console.log('Server listening on port 3000');
});
