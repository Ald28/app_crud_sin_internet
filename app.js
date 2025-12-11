import express from 'express';
import userRoutes from './routes/userRoutes.js';
import productRoutes from './routes/productRoutes.js';
import dotenv from "dotenv";
dotenv.config();

const app = express();

app.use(express.json());
app.use('/users', userRoutes);
app.use('/products', productRoutes);

export default app;