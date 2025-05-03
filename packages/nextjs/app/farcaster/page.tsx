import { fetchMetadata } from "frames.js/next";
import { getFramesUrl } from "~~/utils/frames";

export async function generateMetadata() {
  return {
    title: "My Page",
    // provide a full URL to your /frames endpoint
    other: await fetchMetadata(new URL("/frames", getFramesUrl(""))),
  };
}

export default function Page() {
  return <span>My existing page</span>;
}
