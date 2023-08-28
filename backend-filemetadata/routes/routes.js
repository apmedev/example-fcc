const express = require('express');
const router = express.Router();
const multer = require('multer');
const storage = multer.memoryStorage(); 
const upload = multer({ storage: storage }); 

const fileMulter = require('../file/metadata');

router.route('/api/file-size').post(upload.single('file'),fileMulter.parse);
router.route('/api').post(upload.single('file'),fileMulter.parse);

router.get('*', (req, res) => {
  const fullUrl = req.protocol + '://' + req.get('host') + req.originalUrl;
  res.render('index.pug', {
    fullUrl: fullUrl,
    title: 'File Metadata Microservice'
  });
});

module.exports = router;