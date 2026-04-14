import {
  NavigationMenu,
  NavigationMenuItem,
  NavigationMenuList,
} from "@/components/ui/navigation-menu";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";

export default function Navbar() {
  const navigate = useNavigate();
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  // 🔥 check token from backend login
  useEffect(() => {
    const token = localStorage.getItem("token");
    setIsLoggedIn(!!token);
  }, []);

  const handleLogout = () => {
    localStorage.removeItem("token");
    setIsLoggedIn(false);
    navigate("/");
  };

  return (
    <div className="border-b bg-background/80 backdrop-blur-md px-8 py-4 flex justify-between items-center sticky top-0 z-50">
      
      {/* LOGO */}
      <h1
        className="text-xl font-bold cursor-pointer"
        onClick={() => navigate("/")}
      >
        🚀 VibeLog
      </h1>

      {/* MENU */}
      <NavigationMenu>
        <NavigationMenuList className="gap-6">
          <NavigationMenuItem onClick={() => navigate("/")}>
            Home
          </NavigationMenuItem>

          <NavigationMenuItem onClick={() => navigate("/create")}>
            Create
          </NavigationMenuItem>

          <NavigationMenuItem>
            Explore
          </NavigationMenuItem>
        </NavigationMenuList>
      </NavigationMenu>

      {/* 🔥 LOGIN / LOGOUT */}
      {isLoggedIn ? (
        <Button variant="destructive" onClick={handleLogout}>
          Logout
        </Button>
      ) : (
        <div className="flex items-center gap-3">
          <Button variant="outline" onClick={() => navigate("/register")}>
            Register
          </Button>
          <Button onClick={() => navigate("/login")}> 
            Login
          </Button>
        </div>
      )}
    </div>
  );
}