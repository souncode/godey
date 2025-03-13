const app = require('./app');

const port = 3000;

app.get('/',(req,res)=>{
    res.send("hellu")
});

app.listen(port,()=>{
    console.log(`Server listing on Port http://localhost:${port}`);
});