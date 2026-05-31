using System.Web;

namespace TroikaClothingWeb.Services
{
    public static class ThemeService
    {
        private const string ThemeCookieName = "TroikaTheme";

        public static string GetCurrentTheme(HttpRequest request)
        {
            string value = request?.Cookies[ThemeCookieName]?.Value;
            return value == "dark" ? "dark" : "light";
        }

        public static void SaveTheme(HttpResponse response, string theme)
        {
            string safeTheme = theme == "dark" ? "dark" : "light";
            response.Cookies.Set(new HttpCookie(ThemeCookieName, safeTheme)
            {
                Expires = System.DateTime.Now.AddYears(1)
            });
        }
    }
}
