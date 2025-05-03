export const getFramesUrl = (path: string | undefined) => {
  // if the path is empty, return the base url
  if (!path || path === "") {
    return process.env.NEXT_PUBLIC_URL ? `${process.env.NEXT_PUBLIC_URL}` : "http://localhost:3000";
  }

  return process.env.NEXT_PUBLIC_URL ? `${process.env.NEXT_PUBLIC_URL}/${path}` : `http://localhost:3000/${path}`;
};
