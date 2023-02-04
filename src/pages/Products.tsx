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
  const maxPage = Math.ceil(products.length / productsPerPage)

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

  function handleProductsPerPageChange(e: React.ChangeEvent<HTMLInputElement>) {
    setProductsPerPage(parseInt(e.target.value))
    setPage(1)
  }

  return (
    <div>
      <div className="flex items-center bg-blue-600 py-3 px-3 text-white shadow-md">
        <h1 className="grow text-2xl font-bold">Products</h1>
        <div className="relative">
          <label htmlFor="nb-products" className="mr-3 text-sm">
            per page
          </label>
          <input
            id="nb-products"
            type="number"
            placeholder={productsPerPage.toString()}
            value={productsPerPage}
            max={products.length}
            min={1}
            onChange={handleProductsPerPageChange}
            className="w-[50px] rounded-md border border-white bg-transparent p-1 text-center text-sm text-white"
          />
        </div>
      </div>

      {isLoading && <div className="mt-5 text-center text-3xl font-bold">Loading...</div>}
      {!isLoading && (
        <div>
          <div className="px-2">
            {currentProducts?.map(product => (
              <div key={product.id} className="my-2 flex flex-col justify-between rounded-md bg-gray-100 p-3 shadow-md">
                <div className="flex items-center border-b border-b-gray-300">
                  <span className="grow text-sm font-bold uppercase">Name</span>
                  <span className="ml-2 truncate text-sm">{product.name}</span>
                </div>
                <div className="flex items-center border-b border-b-gray-300">
                  <span className="grow text-sm font-bold uppercase">Stock</span>
                  <span className="ml-2 text-sm"> {new Intl.NumberFormat("fr-FR").format(product.stock)}</span>
                </div>
                <div className="flex items-center border-b border-b-gray-300">
                  <span className="grow text-sm font-bold uppercase">Price</span>
                  <span className="ml-2 text-sm">
                    {new Intl.NumberFormat("fr-FR", { style: "currency", currency: "EUR" }).format(
                      parseInt(product.details.price),
                    )}
                  </span>
                </div>
                <div className="flex items-center border-b border-b-gray-300">
                  <span className="grow text-sm font-bold uppercase">Color</span>
                  <span className="ml-2 text-sm">{product.details.color}</span>
                </div>
                <button className="mt-2 flex appearance-none items-center justify-center gap-1 self-start rounded-sm bg-blue-500 p-2 text-xs text-white">
                  View this product
                  <AiOutlineRight size={15} />
                </button>
              </div>
            ))}
          </div>
          <div className="flex items-center justify-center gap-2">
            <button onClick={() => setPage(1)} className="rounded-md bg-gray-100 p-2">
              <div className="flex">
                <span className="mr-[-10px]">
                  <AiOutlineLeft />
                </span>
                <span>
                  <AiOutlineLeft />
                </span>
              </div>
            </button>
            <button onClick={handlePreviousPage} className="rounded-md bg-gray-100 p-2">
              <AiOutlineLeft />
            </button>
            <span>
              {page}/{maxPage}
            </span>
            <button onClick={handleNextPage} className="rounded-md bg-gray-100 p-2">
              <AiOutlineRight />
            </button>
            <button onClick={() => setPage(maxPage)} className="rounded-md bg-gray-100 p-2">
              <div className="flex">
                <span className="mr-[-10px]">
                  <AiOutlineRight />
                </span>
                <span>
                  <AiOutlineRight />
                </span>
              </div>
            </button>
          </div>
        </div>
      )}
    </div>
  )
}

export default Products
