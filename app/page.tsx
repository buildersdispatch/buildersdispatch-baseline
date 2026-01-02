export default function Home() {
  return (
    <main
      style={{
        minHeight: "100vh",
        background: "linear-gradient(180deg, #0b0b0b 0%, #111 100%)",
        color: "#f5f5f5",
        display: "flex",
        flexDirection: "column",
        justifyContent: "space-between",
        fontFamily:
          "system-ui, -apple-system, BlinkMacSystemFont, Segoe UI, sans-serif",
      }}
    >
      {/* HERO */}
      <section
        style={{
          padding: "80px 24px",
          textAlign: "center",
        }}
      >
        <h1
          style={{
            fontSize: "42px",
            marginBottom: "16px",
            letterSpacing: "-0.02em",
          }}
        >
          BuildersDISPATCH
        </h1>

        <p
          style={{
            maxWidth: 720,
            margin: "0 auto",
            fontSize: "18px",
            lineHeight: 1.6,
            color: "#cfcfcf",
          }}
        >
          A modern platform for the construction industry — connecting people,
          projects, and execution.
        </p>

        <p
          style={{
            marginTop: 32,
            fontSize: 14,
            color: "#888",
          }}
        >
          Platform launching soon.
        </p>
      </section>

      {/* FOOTER */}
      <footer
        style={{
          borderTop: "1px solid #222",
          padding: "20px 24px",
          fontSize: 13,
          color: "#777",
          textAlign: "center",
        }}
      >
        © {new Date().getFullYear()} BuildersDISPATCH · All rights reserved
      </footer>
    </main>
  );
}
