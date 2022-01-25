title: colourised SQL
date: 09-02-2020

<<<<<<< HEAD:md/notes/colourised_sql.md
Databases are the heart of modern web apps. Sensible developers see the web as various technologies (HTML, URLs, HTTP) or more abstractly as a directed graph. Their view is truthful but boring. I like to see the web as a global party attended by databases dressed in flat-design.
=======
Databases are the heart of modern web apps. Sensible developers see the web as various technologies (HTML, URLs, HTTP) or more abstractly as a [directed graph](https://computersciencewiki.org/index.php/The_web_as_a_directed_graph). Their view is truthful but boring. I prefer to see the web as a global party attended by databases dressed in [flat-design](https://en.wikipedia.org/wiki/Flat_design).
>>>>>>> 74180eb06f37d9650f80da81328afec823601f53:md/notes/archived/colourised_sql.md

Most of these databases speak SQL, which makes SQL handy to know. And yet many junior developers don’t. How come?

One reason is just: bad PR. SQL is old and, for some, evokes images of dusty DBAs ensconced in megacorps. Another reason though is that SQL seems *weird*. Or at least it seems so if all you know is Ruby.

Ignore this weirdness. SQL is a small language. Handful of verbs really. It’s also a language that rewards thinking in pictures: you grasp the language better if you visualise how it acts. Which there is a trick to, at least for the very basics. *It’s to colour in your tables*.

<<<<<<< HEAD:md/notes/colourised_sql.md
Here’s an example:

Colour mapping clauses to table parts reveals clause concepts. To show we read from the author table, we map the FROM clause to the table. To show we filter rows on age, we map the WHERE clause to result rows. To show we select names, we map the SELECT to result data.
=======
Random example for a table called authors:
<img src="../assets/authors_copy.png">
Colour mapping clauses to tables reveals clause concepts. To show we read from author, we map the FROM clause to the table. To show we filter rows on age, we map the WHERE clause to result rows. To show we select names, we map the SELECT to data.

This is a fun way to build SQL intuition. But only at first. Once you know some SQL the colours become sensory noise — I want to understand queries, not practically taste them — and I’m unsure how colourised SQL would work for more advanced stuff like JOINS, etc.
>>>>>>> 74180eb06f37d9650f80da81328afec823601f53:md/notes/archived/colourised_sql.md

This is a fun way to get SQL intuition. But only at first. With knowledge the colours become more overwhelming than helpful -- I want to understand my queries, not practically taste them -- and I’m not sure how colourised SQL would work for more advanced queries like JOINS, etc.

Still, maybe a decent learning hack for beginners.
