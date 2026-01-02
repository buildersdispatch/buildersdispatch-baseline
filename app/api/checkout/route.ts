import { NextResponse } from "next/server";

export async function POST() {
  const res = await fetch(
    "https://staging.crossmint.com/api/2022-06-09/orders",
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-client-secret": process.env.CROSSMINT_SERVER_API_KEY!,
      },
      body: JSON.stringify({
        lineItems: [
          {
            collectionLocator: `crossmint:${process.env.CROSSMINT_COLLECTION_ID}`,
            callData: {
              totalPrice: "0.001",
              quantity: 1,
            },
          },
        ],
        payment: {
          crypto: { enabled: true },
          fiat: { enabled: true },
        },
        recipient: {
          email: "buyer@example.com",
        },
        locale: "en-US",
      }),
    }
  );

  const data = await res.json();

  return NextResponse.json({
    orderId: data.orderId,
    clientSecret: data.clientSecret,
  });
}
