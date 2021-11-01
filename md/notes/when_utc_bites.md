title: When UTC Bites
date: 28-06-2020 07:52:56 UTC
tags: web, work

Lately, I’ve been working on a feature to do with time. Many devs learn to fear time. A friend once joked that a simple measure of developer experience is how triggered they get on hearing words like “datetimes, “time zones” and - brace yourself  - “daylight saving time”.
{: .dropcap}
I think I’m starting to understand this fear. Working with time in code can be hard. Offset edge cases pile up. Conversion logic snowballs. You find momentary relief in [funny stories](https://www.si.com/extra-mustard/2013/12/30/the-extra-mustard-trivia-hour-when-a-calendar-defeated-russia-in-the-1908-olympics?utm_source=reddit.com) about time but that fades and then again you wonder: _surely there’s a better way to code this?_

Stack Overflow to the rescue.

The basic [industry advice](https://stackoverflow.com/questions/2532729/daylight-saving-time-and-time-zone-best-practices?lq=1) for handling time is well known. It’s to store datetimes as UTC and convert to local time later. Doing this worked well for me once before, and for my current feature I guessed it would again. But instead I discovered an interesting exception.

Storing datetimes as UTC works well for _past_ events, or for future _absolute_ events, but it doesn’t work so great for future local events, especially future _recurring_ events - which is what I’m working on.

An example can show the problem.

Suppose it’s January 2020 again. You want to build an app. Ignoring the [warnings](https://techcommunity.microsoft.com/t5/exchange-team-blog/calendaring-is-really-hard-to-code-and-that-s-why-you-were-an/ba-p/1165583) your dork friends have shouted about forever, you decide to make a calendar app. And because you always double down on terrible life choices, you decide it will support recurring events too.

As a test of the app, you want to recur a meeting in the UK for 9.00am every Monday. Each meeting will be created by a class and backed by a table row with a start_at column. You hand the class a time zone, recurrence rule, and start at time to create these meetings.

You run the class - an unholy number of early-morning meetings appear. You check the database to see each row starts at 9.00am local time on Monday (e.g. UTC 2020-01-01 09:00:00, 2020-01-02 09:00:00, etc). You also see that DST applies. The Monday after the clocks change reads 2020-03-30 08:00:00 UTC because the UK is now on BST. Software, ahem, saves the day.

But actually, maybe not?

Time zone rules can change. Suppose the UK finally scrapped BST. You’d have an issue, because now your table rows from March 29th have a wrong start time of 08:00:00 UTC (8:00am GMT). This is why UTC is not always the best way to store datetimes. Future UTC datetimes are not resistant to changes in the rules they were calculated by and so storing UTC in this case is risky.

Of course, exactly how risky it is will depend. A local scheduling app, in just one time zone, could likely eat the cost of recalculating datetimes if needed. Yet the same may not be true at scale. My point is just that storing UTC _can_ bite you, so think it through. Time zone rules change [often enough](https://codeofmatt.com/on-the-timing-of-time-zone-changes/). And governments sometimes make these changes with little notice, meaning even if recalculating the necessary datetimes is feasible, it might be a painful squeeze.

Stay alert out there ;)
