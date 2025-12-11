import prisma from "../database/prisma.js";

export const registerProduct = async (req, res) => {
    try {
        const userId = req.user.id;

        const { name, price } = req.body;

        const newProduct = await prisma.product.create({
            data: {
                name,
                price: parseFloat(price),
                userId
            }
        });

        res.status(201).json({ message: "Product registered successfully", product: newProduct });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Internal server error" });
    }
}

export const listProducts = async (req, res) => {
    try {

        const page = parseInt(req.query.page) || 1;
        const limit = 5;
        const skip = (page - 1) * limit;

        const [products, total] = await Promise.all([
            prisma.product.findMany({
                skip,
                take: limit,
                include: {
                    user: {
                        select: { email: true }
                    }
                }
            }),
            prisma.product.count()
        ]);

        res.status(200).json({
            page,
            totalPages: Math.ceil(total / limit),
            totalItems: total,
            products
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Internal server error" });
    }
}