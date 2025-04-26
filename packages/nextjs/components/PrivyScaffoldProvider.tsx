"use client";

import { PropsWithChildren } from "react";
import { PrivyProvider } from "@privy-io/react-auth";

export const PrivyScaffoldProvider = ({ children }: PropsWithChildren) => {
  return (
    <PrivyProvider
      appId="cm09stjha011x8j4lpu8gt9jt" //update this to {process.env.NEXT_PUBLIC_PRIVY_API_KEY}
      config={{
        // Customize Privy's appearance in your app
        appearance: {
          theme: "light",
          accentColor: "#676FFF",
          logo: "https://your-logo-url",
        },
        loginMethods: ["email", "wallet", "google", "apple", "farcaster"],
        // Create embedded wallets for users who don't have a wallet
        embeddedWallets: {
          createOnLogin: "users-without-wallets",
        },
      }}
    >
      {children}
    </PrivyProvider>
  );
};
