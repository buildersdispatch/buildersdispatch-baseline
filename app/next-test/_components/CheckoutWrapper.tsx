"use client";

import React from "react";
import {
  CrossmintProvider,
  CrossmintCheckoutProvider,
  CrossmintHostedCheckout,
} from "@crossmint/client-sdk-react-ui";

export type DisplayMode = "same-tab" | "popup" | "new-tab";
export type ButtonTheme = "light" | "dark" | "crossmint";
export type CheckoutTheme = "light" | "dark";
export type DefaultMethod = "fiat" | "crypto";

export type CheckoutWrapperConfig = {
  // UX
  display: DisplayMode;
  buttonTheme: ButtonTheme;
  checkoutTheme: CheckoutTheme;
  overlayEnabled: boolean;
  accent: string;
  buttonLabel: string;

  // Checkout inputs
  qty: number;
  totalPrice: string;
  recipientEmail: string;
  receiptEmail: string;

  // Payment toggles
  fiatEnabled: boolean;
  cryptoEnabled: boolean;
  defaultMethod: DefaultMethod;

  // NOTE: shown in the lab UI, but intentionally NOT passed into the SDK
  // until we wire the exact enum types Crossmint expects.
  fiatCurrency: string;
  cryptoChain: string;
  cryptoCurrency: string;
};

export function CheckoutWrapper({
  clientApiKey,
  collectionId,
  cfg,
  missingEnv,
}: {
  clientApiKey: string;
  collectionId: string;
  cfg: CheckoutWrapperConfig;
  missingEnv: string[];
}) {
  if (missingEnv.length > 0) {
    return (
      <div style={{ opacity: 0.8 }}>
        Set the env vars and restart the Next process to enable the hosted checkout component.
      </div>
    );
  }

  return (
    <CrossmintProvider apiKey={clientApiKey}>
      <CrossmintCheckoutProvider>
        <CrossmintHostedCheckout
          // Locked “Crossmint end” shape (safe knobs only):
          lineItems={[
            {
              collectionLocator: `crossmint:${collectionId}`,
              callData: {
                totalPrice: cfg.totalPrice,
                quantity: cfg.qty,
              },
            },
          ]}
          appearance={{
            display: cfg.display,
            overlay: { enabled: cfg.overlayEnabled },
            theme: { button: cfg.buttonTheme, checkout: cfg.checkoutTheme },
            variables: { colors: { accent: cfg.accent } },
          }}
          payment={{
            fiat: { enabled: cfg.fiatEnabled },
            crypto: { enabled: cfg.cryptoEnabled },
            defaultMethod: cfg.defaultMethod,
            receiptEmail: cfg.receiptEmail,
          }}
          recipient={{ email: cfg.recipientEmail }}
          locale="en-US"
        >
          {cfg.buttonLabel}
        </CrossmintHostedCheckout>

        <div style={{ marginTop: "0.75rem", opacity: 0.75, fontSize: 13 }}>
          Tip: if you change env vars, rebuild + restart PM2.
        </div>
      </CrossmintCheckoutProvider>
    </CrossmintProvider>
  );
}
