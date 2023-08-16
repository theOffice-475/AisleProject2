# AisleProject2

Project1:
For Project 1, to refresh the number of daily Likes for each user at 12pm local time in a scalable way:

1. I would store each user's time zone in their user profile in the database.
2. I would run a scheduled job (using something like cron) every hour to check for any users where the 
   current hour is 12pm in their time zone.
3. For those users, I would reset the number of Likes remaining for the day to 10 by updating their record in the database.
4. To make this scalable, I could run the cron job across multiple servers, and shard the users across databases/servers so 
   each server only needs to process a subset of users.
5. I could also optimize the query to pull only users where the time zone matches rather than scanning all users.
6. The cron job would handle daylight savings time adjustments automatically based on the system time.

https://github.com/theOffice-475/AisleProject2/assets/66066206/c3079f39-8ff9-4629-9a11-cb5a86e2650f

