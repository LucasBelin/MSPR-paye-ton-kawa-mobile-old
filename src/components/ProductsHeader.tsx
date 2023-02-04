import { BiLogOutCircle } from "react-icons/bi"
import { useNavigate } from "react-router-dom"

function ProductsHeader() {
  const navigate = useNavigate()

  function handleLogout() {
    navigate("/")
  }

  return (
    <header className="flex w-full bg-blue-500 py-3 px-3">
      <button onClick={handleLogout}>
        <BiLogOutCircle color="white" size={30}></BiLogOutCircle>
      </button>
      <h1 className="grow justify-self-center text-center text-3xl font-bold uppercase tracking-wider text-white">
        Products
      </h1>
    </header>
  )
}

export default ProductsHeader
