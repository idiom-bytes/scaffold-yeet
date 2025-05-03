/* eslint-disable react/jsx-key */
import { frames } from "./frames";
import { Button } from "frames.js/next";
import { getFramesUrl } from "~~/utils/frames";

const handleRequest = frames(async () => {
  return {
    image: getFramesUrl("favicon_large.png"),
    buttons: [
      <Button action="post" target={{ query: { value: "Yes" } }}>
        Say Yes
      </Button>,
      <Button action="post" target={{ query: { value: "No" } }}>
        Say No
      </Button>,
    ],
  };
});

export const GET = handleRequest;
export const POST = handleRequest;
