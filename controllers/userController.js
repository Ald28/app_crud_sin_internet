import prisma from "../database/prisma.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

export const registerUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        if(!email || !password) {
            return res.status(400).json({ message: "Email and password are required" });
        }

        if(email.trim() === "" || password.trim() === "") {
            return res.status(400).json({ message: "Email and password cannot be empty" });
        }

        const existingUser = await prisma.user.findUnique({
            where: { email }
        });

        if (existingUser) {
            return res.status(400).json({ message: "User already exists" });
        }

        const HashedPassword = await bcrypt.hash(password, 10);

        let userRole = await prisma.role.findUnique({
            where: { name: "USER" }
        });

        if (!userRole) {
            userRole = await prisma.role.create({
                data: { name: "USER" }
            });
        }

        const newUser = await prisma.user.create({
            data: {
                email,
                password: HashedPassword,
                roleId: userRole.id
            }
        });

        const token = jwt.sign(
            { id: newUser.id, role: userRole.name },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRES }
        );

        res.status(201).json({ message: "User registered successfully", token, userId: newUser.id });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Internal server error" });
    }
}

export const loginUser = async (req, res) => {
    try {

        const { email, password } = req.body;

        const user = await prisma.user.findUnique({
            where: { email },
            include: { role: true }
        });

        if (!user) {
            return res.status(400).json({ message: "Invalid credentials" });
        }

        const isPasswordValid = await bcrypt.compare(password, user.password);

        if (!isPasswordValid) {
            return res.status(400).json({ message: "Invalid credentials" });
        }

        const token = jwt.sign(
            { id: user.id, role: user.role.name },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRES }
        );

        res.status(200).json({
            message: "Login successful", token,
            userId: user.id,
            role: user.role.name
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Internal server error" });
    }
}