using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(TroikaClothingWeb.Startup))]
namespace TroikaClothingWeb
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
