import QRCode from "react-qr-code"

function Login() {
  return (
    <>
      <img src="/src/assets/logo.png"></img>
      <div>Login</div>
      <div id="qrcode">
        <QRCode value="http://192.168.56.1:3000/" />
      </div>
    </>
  )
}

export default Login
