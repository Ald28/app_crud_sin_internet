import express from "express";
import { registerProduct, listProducts } from "../controllers/productController.js";
import { verifyToken } from "../middleware/auth.js";

const router = express.Router();

router.post("/register", verifyToken,registerProduct);
router.get("/list", listProducts);

export default router;