using System;

namespace TroikaClothingWeb.Common
{
    /// <summary>
    /// Supplies the current South African time (SAST, UTC+02:00).
    ///
    /// The site is hosted on Azure App Service, whose worker process runs in UTC, so
    /// <see cref="DateTime.Now"/> stamped orders two hours behind the customer's actual
    /// local time and receipts showed the wrong time. Every timestamp the customer sees
    /// (order date on the receipt, sale history, reports) must come from here instead,
    /// so the value is the same no matter which region the site is deployed to.
    ///
    /// South Africa has no daylight saving, so the offset is a constant +02:00.
    /// </summary>
    public static class SaTime
    {
        private const string WindowsId = "South Africa Standard Time";
        private const string IanaId = "Africa/Johannesburg";
        private static readonly TimeSpan FixedOffset = TimeSpan.FromHours(2);

        private static readonly TimeZoneInfo SouthAfrica = ResolveTimeZone();

        /// <summary>The current date and time in South Africa (SAST).</summary>
        public static DateTime Now
        {
            get
            {
                if (SouthAfrica != null)
                    return TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, SouthAfrica);

                return DateTime.UtcNow.Add(FixedOffset);
            }
        }

        /// <summary>Today's date in South Africa (SAST), with no time component.</summary>
        public static DateTime Today
        {
            get { return Now.Date; }
        }

        /// <summary>Converts a UTC timestamp to South African time.</summary>
        public static DateTime FromUtc(DateTime utc)
        {
            DateTime value = DateTime.SpecifyKind(utc, DateTimeKind.Utc);

            if (SouthAfrica != null)
                return TimeZoneInfo.ConvertTimeFromUtc(value, SouthAfrica);

            return value.Add(FixedOffset);
        }

        // The time zone database uses different identifiers on Windows and Linux. Try both,
        // and fall back to the fixed offset if neither is registered on the host.
        private static TimeZoneInfo ResolveTimeZone()
        {
            TimeZoneInfo zone = TryFind(WindowsId);
            return zone ?? TryFind(IanaId);
        }

        private static TimeZoneInfo TryFind(string id)
        {
            try
            {
                return TimeZoneInfo.FindSystemTimeZoneById(id);
            }
            catch (TimeZoneNotFoundException)
            {
                return null;
            }
            catch (InvalidTimeZoneException)
            {
                return null;
            }
        }
    }
}
