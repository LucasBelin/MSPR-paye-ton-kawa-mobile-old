import { z } from "zod"

export const ProductSchema = z.object({
  id: z.string(),
  name: z.string(),
  stock: z.number(),
  details: z.object({
    description: z.string(),
    color: z.string(),
    price: z.string(),
  }),
})
export type Product = z.infer<typeof ProductSchema>

export const ProductsResponseSchema = z.array(ProductSchema)
