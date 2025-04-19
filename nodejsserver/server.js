const express = require('express');
const path = require('path');

const app = require('./app');
// Cấu hình cổng
const portApi = 3000;
//const portWeb = 80;

// Middleware để phục vụ các file tĩnh như HTML, CSS, JS cho trang web
app.use(express.static('/home/soun/workspace/xtth.wap.sh'));

// API: Khi truy cập vào /api sẽ trả về thông báo
app.get('/api', (req, res) => {
    res.send("Get from server successfully");
});

// Web: Khi truy cập vào trang chủ, sẽ phục vụ file index.html
app.get('/', (req, res) => {
    res.sendFile(path.join('/home/soun/workspace/xtth.wap.sh', 'index.html'));
});
//app.listen(portWeb, "0.0.0.0", () => {
//   console.log(`Web server running at http://0.0.0.0:${portWeb}`);
//});

// Lắng nghe trên port 3000 cho API
app.listen(portApi, "0.0.0.0", () => {
    console.log(`API server running at http://0.0.0.0:${portApi}`);
});


