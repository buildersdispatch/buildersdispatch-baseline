"use client";

import { useEffect } from "react";
import {
  CrossmintProvider,
  CrossmintCheckoutProvider,
  CrossmintHostedCheckout,
  useCrossmintCheckout,
} from "@crossmint/client-sdk-react-ui";

function Checkout() {
  const { order } = useCrossmintCheckout();
  const collectionId = process.env.NEXT_PUBLIC_COLLECTION_ID as string;

  useEffect(() => {
    if (order && order.phase === "completed") {
      console.log("Purchase completed!");
    }
  }, [order]);

  return (
    <CrossmintHostedCheckout
      lineItems={[
        {
          collectionLocator: `crossmint:${collectionId}`,
          callData: {
            totalPrice: "0.001",
            quantity: 1,
          },
        },
      ]}
      appearance={{
        display: "new-tab",
        overlay: { enabled: false },
        theme: {
          button: "dark",
          checkout: "dark",
        },
      }}
      payment={{
        crypto: {
          enabled: true,
          defaultChain: "polygon",
          defaultCurrency: "matic",
        },
        fiat: {
          enabled: true,
          defaultCurrency: "usd",
        },
        receiptEmail: "receipt@example.com",
      }}
      recipient={{
        email: "buyer@example.com",
      }}
      locale="en-US"
    />
  );
}

export default function Page() {
  const clientApiKey = process.env.NEXT_PUBLIC_CLIENT_API_KEY as string;

  return (
    <div style={{ padding: "2rem" }}>
      <CrossmintProvider apiKey={clientApiKey}>
        <CrossmintCheckoutProvider>
          <Checkout />
        </CrossmintCheckoutProvider>
      </CrossmintProvider>
    </div>
  );
}
