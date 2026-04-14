import { createTheme } from "@mui/material/styles";

const theme = createTheme({
  palette: {
    mode: "dark",
    background: {
      default: "#0B1120",
      paper: "#111827",
    },
    primary: {
      main: "#6366F1",
    },
    text: {
      primary: "#E5E7EB",
      secondary: "#9CA3AF",
    },
  },
  typography: {
    fontFamily: "Poppins, sans-serif",
  },
});

export default theme;