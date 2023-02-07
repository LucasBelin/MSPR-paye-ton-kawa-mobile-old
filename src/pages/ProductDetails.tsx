import axios from "axios"
import { useState } from "react"
import { useQuery } from "react-query"
import { useParams } from "react-router-dom"
import { Product, ProductSchema } from "../schemas/ProductSchemas"

function ProductDetails() {
  const [product, setProduct] = useState<Product>()
  const { id } = useParams()
  const { isLoading, isError, data, error } = useQuery("products", async () => {
    const res = await axios.get(`https://615f5fb4f7254d0017068109.mockapi.io/api/v1/products/${id}`)
    ProductSchema.safeParse(res.data)
    setProduct(res.data)
    return res.data
  })
  return <div>Product {product?.details?.description}</div>
}

export default ProductDetails
