#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/root/next-test"
ROUTE_DIR="$APP_DIR/app/button-test"
PAGE_FILE="$ROUTE_DIR/page.tsx"
PM2_APP="buildersdispatch-next"

cd "$APP_DIR"

echo "=== Creating /button-test route (leaves / unchanged) ==="

# Safety: confirm we are in a Next.js app router project
if [[ ! -d "$APP_DIR/app" ]]; then
  echo "ERROR: $APP_DIR/app not found"
  exit 1
fi

# DO NOT TOUCH homepage; just show it exists
if [[ -f "$APP_DIR/app/page.tsx" ]]; then
  echo "OK: homepage exists at app/page.tsx (not modifying)"
else
  echo "WARN: app/page.tsx not found (still not modifying anything)"
fi

mkdir -p "$ROUTE_DIR"

# Write page.tsx EXACTLY as provided (no edits)
cat <<'TSX' > "$PAGE_FILE"
"use client";

import { useEffect } from "react";
import {
    CrossmintProvider,
    CrossmintCheckoutProvider,
    CrossmintHostedCheckout,
    useCrossmintCheckout,
} from "@crossmint/client-sdk-react-ui";

// Component with purchase tracking
function Checkout() {
    const { order } = useCrossmintCheckout();
    const collectionId = process.env.NEXT_PUBLIC_COLLECTION_ID as string;

    useEffect(() => {
        if (order && order.phase === "completed") {
            console.log("Purchase completed!");
            // Handle successful purchase
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
                {
                    collectionLocator: `crossmint:${collectionId}`,
                    callData: {
                        totalPrice: "0.002",
                        quantity: 2,
                    },
                },
        ]}
        appearance={{
    // Display mode: how the checkout opens
    display: "same-tab", // Options: "popup" | "new-tab" | "same-tab"
    
    // Overlay: controls the dark backdrop behind the modal (popup mode only)
    overlay: { 
        enabled: true // true = dark semi-transparent background, false = no overlay
    },
    
    // Theme settings
    theme: {
        button: "dark",    // Options: "light" | "dark" | "DISPATCH"
        checkout: "dark",  // Options: "light" | "dark"
    },
    
    // Custom accent color
    variables: {
        colors: {
            accent: "#FF5F15", // Your custom accent color for the button
        },
    },
}}

        payment={{
            crypto: {
                enabled: true,
                defaultChain: "polygon", // Set preferred blockchain
                defaultCurrency: "matic", // Set preferred crypto
            },
            fiat: {
                enabled: true,
                defaultCurrency: "usd", // Set preferred fiat currency
            },
            receiptEmail: "receipt@example.com", // Optional: Set receipt email
        }}
        recipient={{
            email: "buyer@example.com", // Digital assets will be delivered to this email's wallet
            // Or use walletAddress: "0x..." for direct delivery
        }}
        locale="en-US" // Set interface language
    />
);

}

// Main component with providers
export default function Home() {
    const clientApiKey = process.env.NEXT_PUBLIC_CLIENT_API_KEY as string;

    return (
        <div className="flex flex-col items-center justify-start min-h-screen p-6">
            <CrossmintProvider apiKey={clientApiKey}>
                <CrossmintCheckoutProvider>
                    <Checkout />
                </CrossmintCheckoutProvider>
            </CrossmintProvider>
        </div>
    );
}
TSX

echo "=== Build (production) ==="
npm run build

echo "=== Restart PM2 ==="
pm2 restart "$PM2_APP" --update-env

echo "DONE"
echo "Open: https://buildersdispatch.com/button-test"
