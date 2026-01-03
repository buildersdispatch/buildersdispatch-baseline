#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/root/next-test"
PAGE_DIR="$APP_DIR/app/next-test"
PAGE_FILE="$PAGE_DIR/page.tsx"
PM2_APP="buildersdispatch-next"

cd "$APP_DIR"

mkdir -p "$PAGE_DIR"

cat <<'TSX' > "$PAGE_FILE"
"use client";

import { useMemo, useState } from "react";
import {
  CrossmintProvider,
  CrossmintCheckoutProvider,
  CrossmintHostedCheckout,
} from "@crossmint/client-sdk-react-ui";

export default function Page() {
  const clientApiKey = process.env.NEXT_PUBLIC_CLIENT_API_KEY as string;
  const collectionId = process.env.NEXT_PUBLIC_COLLECTION_ID as string;

  // Controls
  const [display, setDisplay] = useState<"popup" | "new-tab" | "same-tab">("same-tab");
  const [buttonTheme, setButtonTheme] = useState<"light" | "dark" | "crossmint">("dark");
  const [checkoutTheme, setCheckoutTheme] = useState<"light" | "dark">("dark");
  const [overlayEnabled, setOverlayEnabled] = useState<boolean>(false);
  const [accent, setAccent] = useState<string>("#FF0000");
  const [qty, setQty] = useState<number>(1);
  const [totalPrice, setTotalPrice] = useState<string>("0.001");
  const [recipientEmail, setRecipientEmail] = useState<string>("buyer@example.com");
  const [receiptEmail, setReceiptEmail] = useState<string>("receipt@example.com");
  const [fiatEnabled, setFiatEnabled] = useState<boolean>(true);
  const [cryptoEnabled, setCryptoEnabled] = useState<boolean>(true);
  const [defaultMethod, setDefaultMethod] = useState<"fiat" | "crypto">("fiat");

  const missing = useMemo(() => {
    const m: string[] = [];
    if (!clientApiKey) m.push("NEXT_PUBLIC_CLIENT_API_KEY");
    if (!collectionId) m.push("NEXT_PUBLIC_COLLECTION_ID");
    return m;
  }, [clientApiKey, collectionId]);

  return (
    <div style={{ padding: "2rem", maxWidth: 980, margin: "0 auto", fontFamily: "system-ui, -apple-system, Segoe UI, Roboto, sans-serif" }}>
      <h1 style={{ fontSize: "1.6rem", marginBottom: "0.25rem" }}>Crossmint Button / Display Test</h1>
      <p style={{ marginTop: 0, opacity: 0.8 }}>Route: <code>/next-test</code></p>

      {missing.length > 0 && (
        <div style={{ padding: "1rem", border: "1px solid #f00", borderRadius: 8, marginBottom: "1rem" }}>
          <strong>Missing env:</strong> {missing.join(", ")}<br />
          Expected in <code>.env.local</code>:<br />
          <code>NEXT_PUBLIC_CLIENT_API_KEY=...</code><br />
          <code>NEXT_PUBLIC_COLLECTION_ID=...</code>
        </div>
      )}

      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "1rem", marginBottom: "1.25rem" }}>
        <div style={{ border: "1px solid #ddd", borderRadius: 10, padding: "1rem" }}>
          <h2 style={{ fontSize: "1.1rem", marginTop: 0 }}>Appearance</h2>

          <label style={{ display: "block", marginBottom: 10 }}>
            Display
            <select value={display} onChange={(e) => setDisplay(e.target.value as any)} style={{ display: "block", width: "100%", marginTop: 6 }}>
              <option value="same-tab">same-tab</option>
              <option value="popup">popup</option>
              <option value="new-tab">new-tab</option>
            </select>
          </label>

          <label style={{ display: "block", marginBottom: 10 }}>
            Button theme
            <select value={buttonTheme} onChange={(e) => setButtonTheme(e.target.value as any)} style={{ display: "block", width: "100%", marginTop: 6 }}>
              <option value="dark">dark</option>
              <option value="light">light</option>
              <option value="crossmint">crossmint</option>
            </select>
          </label>

          <label style={{ display: "block", marginBottom: 10 }}>
            Checkout theme
            <select value={checkoutTheme} onChange={(e) => setCheckoutTheme(e.target.value as any)} style={{ display: "block", width: "100%", marginTop: 6 }}>
              <option value="dark">dark</option>
              <option value="light">light</option>
            </select>
          </label>

          <label style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 10 }}>
            <input type="checkbox" checked={overlayEnabled} onChange={(e) => setOverlayEnabled(e.target.checked)} />
            Overlay enabled
          </label>

          <label style={{ display: "block", marginBottom: 10 }}>
            Accent color
            <input value={accent} onChange={(e) => setAccent(e.target.value)} style={{ display: "block", width: "100%", marginTop: 6 }} />
          </label>
        </div>

        <div style={{ border: "1px solid #ddd", borderRadius: 10, padding: "1rem" }}>
          <h2 style={{ fontSize: "1.1rem", marginTop: 0 }}>Checkout Inputs</h2>

          <label style={{ display: "block", marginBottom: 10 }}>
            Quantity
            <input
              type="number"
              min={1}
              value={qty}
              onChange={(e) => setQty(Math.max(1, Number(e.target.value || 1)))}
              style={{ display: "block", width: "100%", marginTop: 6 }}
            />
          </label>

          <label style={{ display: "block", marginBottom: 10 }}>
            totalPrice (string)
            <input value={totalPrice} onChange={(e) => setTotalPrice(e.target.value)} style={{ display: "block", width: "100%", marginTop: 6 }} />
          </label>

          <label style={{ display: "block", marginBottom: 10 }}>
            Recipient email
            <input value={recipientEmail} onChange={(e) => setRecipientEmail(e.target.value)} style={{ display: "block", width: "100%", marginTop: 6 }} />
          </label>

          <label style={{ display: "block", marginBottom: 10 }}>
            Receipt email
            <input value={receiptEmail} onChange={(e) => setReceiptEmail(e.target.value)} style={{ display: "block", width: "100%", marginTop: 6 }} />
          </label>

          <div style={{ display: "flex", gap: 14, marginBottom: 10 }}>
            <label style={{ display: "flex", alignItems: "center", gap: 8 }}>
              <input type="checkbox" checked={fiatEnabled} onChange={(e) => setFiatEnabled(e.target.checked)} />
              Fiat
            </label>
            <label style={{ display: "flex", alignItems: "center", gap: 8 }}>
              <input type="checkbox" checked={cryptoEnabled} onChange={(e) => setCryptoEnabled(e.target.checked)} />
              Crypto
            </label>
          </div>

          <label style={{ display: "block" }}>
            Default method
            <select value={defaultMethod} onChange={(e) => setDefaultMethod(e.target.value as any)} style={{ display: "block", width: "100%", marginTop: 6 }}>
              <option value="fiat">fiat</option>
              <option value="crypto">crypto</option>
            </select>
          </label>
        </div>
      </div>

      <div style={{ border: "1px solid #ddd", borderRadius: 10, padding: "1rem" }}>
        <h2 style={{ fontSize: "1.1rem", marginTop: 0 }}>Live Component</h2>

        <CrossmintProvider apiKey={clientApiKey}>
          <CrossmintCheckoutProvider>
            <CrossmintHostedCheckout
              lineItems={[
                {
                  collectionLocator: `crossmint:${collectionId}`,
                  callData: {
                    totalPrice,
                    quantity: qty,
                  },
                },
              ]}
              appearance={{
                display,
                overlay: { enabled: overlayEnabled },
                theme: { button: buttonTheme, checkout: checkoutTheme },
                variables: { colors: { accent } },
              }}
              payment={{
                fiat: { enabled: fiatEnabled, defaultCurrency: "usd" },
                crypto: { enabled: cryptoEnabled, defaultChain: "polygon", defaultCurrency: "matic" },
                defaultMethod,
                receiptEmail,
              }}
              recipient={{ email: recipientEmail }}
              locale="en-US"
            />
          </CrossmintCheckoutProvider>
        </CrossmintProvider>

        <div style={{ marginTop: "0.75rem", opacity: 0.75, fontSize: 13 }}>
          Tip: if you change env vars, rebuild + restart PM2.
        </div>
      </div>
    </div>
  );
}
TSX

echo "=== Build ==="
npm run build

echo "=== PM2 restart ==="
pm2 restart "$PM2_APP" --update-env

echo "DONE"
echo "Open: https://buildersdispatch.com/next-test"
