export const metadata = {
  title: "BuildersDISPATCH",
  description: "BuildersDISPATCH — a modern platform for the construction industry.",
  icons: {
    icon: "/favicon.ico",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <head />
      <body
        style={{
          margin: 0,
          backgroundColor: "#0b0b0b",
          color: "#f5f5f5",
        }}
      >
        {children}
      </body>
    </html>
  );
}
