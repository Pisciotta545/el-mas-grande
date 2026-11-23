import type { NextConfig } from "next";

// GitHub Pages sirve el sitio en /el-mas-grande; en local se usa la raíz.
const basePath = process.env.NEXT_PUBLIC_BASE_PATH ?? "";

const nextConfig: NextConfig = {
  output: "export",
  basePath,
  trailingSlash: true,
  images: { unoptimized: true },
};

export default nextConfig;
