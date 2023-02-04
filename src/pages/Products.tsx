import axios from "axios"
import { useState } from "react"
import { AiOutlineLeft, AiOutlineRight } from "react-icons/ai"
import { useQuery } from "react-query"
import { z } from "zod"

const ProductSchema = z.object({
  id: z.string(),
  name: z.string(),
  stock: z.number(),
  details: z.object({
    description: z.string(),
    color: z.string(),
    price: z.string(),
  }),
})
type Product = z.infer<typeof ProductSchema>

const ProductsResponseSchema = z.array(ProductSchema)

function Products() {
  const [products, setProducts] = useState<Product[]>([])
  const [page, setPage] = useState(1)
  const [productsPerPage, setProductsPerPage] = useState(4)

  const indexOfLastProduct = page * productsPerPage
  const indexOfFirstProduct = indexOfLastProduct - productsPerPage
  const currentProducts = products?.slice(indexOfFirstProduct, indexOfLastProduct)

  const { isLoading, isError, data, error } = useQuery("products", async () => {
    const res = await axios.get("https://615f5fb4f7254d0017068109.mockapi.io/api/v1/products")
    ProductsResponseSchema.safeParse(res.data)
    setProducts(res.data)
    return res.data
  })

  function handleNextPage() {
    if (page < products.length / productsPerPage) setPage(page + 1)
  }

  function handlePreviousPage() {
    if (page > 1) {
      setPage(page - 1)
    }
  }

  return (
    <div>
      <div className="flex items-center bg-blue-600 py-3 px-3 text-white shadow-md">
        <h1 className="grow text-2xl font-bold">Products</h1>
        <div className="relative">
          <label
            htmlFor="nb-products"
            className="absolute top-4 left-2.5 z-10 origin-[0] -translate-y-4 scale-75 transform text-sm text-white duration-300 peer-placeholder-shown:translate-y-0 peer-placeholder-shown:scale-100 peer-focus:-translate-y-4 peer-focus:scale-75 peer-focus:text-blue-600 peer-focus:dark:text-blue-500"
          >
            Products per page
          </label>
          <input
            id="nb-products"
            type="number"
            placeholder={productsPerPage.toString()}
            value={productsPerPage}
            max={products.length}
            min={1}
            onChange={e => setProductsPerPage(parseInt(e.target.value))}
            className="block min-w-[150px] appearance-none rounded-lg border border-gray-300 bg-transparent px-2.5 pb-2.5 pt-4 text-sm text-white placeholder:text-white focus:outline-none focus:ring-0"
          />
        </div>
      </div>

      {isLoading && <div>Loading...</div>}
      {!isLoading && (
        <div className="px-2">
          {currentProducts?.map(product => (
            <div key={product.id} className="my-2 flex flex-col justify-between rounded-md bg-gray-100 p-3 shadow-md">
              <div className="flex items-center border-b border-b-gray-300">
                <span className="text-md grow font-bold uppercase">Name</span>
                <span className="ml-2">{product.name}</span>
              </div>
              <div className="flex items-center border-b border-b-gray-300">
                <span className="text-md grow font-bold uppercase">Stock</span>
                <span className="ml-2">{product.stock}</span>
              </div>
              <div className="flex items-center border-b border-b-gray-300">
                <span className="text-md grow font-bold uppercase">Price</span>
                <span className="ml-2">{product.details.price}</span>
              </div>
              <div className="flex items-center">
                <span className="text-md grow font-bold uppercase">Color</span>
                <span className="ml-2">{product.details.color}</span>
              </div>
              <button className="mt-2 flex appearance-none items-center justify-center gap-1 self-start rounded-md bg-blue-500 p-2 text-xs text-white">
                View this product
                <AiOutlineRight size={15} />
              </button>
            </div>
          ))}
        </div>
      )}
      <div className="flex">
        <button onClick={handlePreviousPage} className="rounded-md bg-gray-100 p-2">
          <AiOutlineLeft />
        </button>
        <button onClick={handleNextPage} className="rounded-md bg-gray-100 p-2">
          <AiOutlineRight />
        </button>
      </div>
    </div>
  )
}

export default Products
