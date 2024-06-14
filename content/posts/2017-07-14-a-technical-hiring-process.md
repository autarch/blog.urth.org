---
title: A Technical Hiring Process
author: Dave Rolsky
type: post
date: 2017-07-14T19:34:36+00:00
url: /2017/07/14/a-technical-hiring-process/
---

At [The Perl Conference 2017][1], I gave a talk titled *How to Make Your Technical Hiring Process
Suck at Least 20% Less*. A Bold goal, I know!

Unfortunately, the video from that talk did not come out. The [slides are available][2] (hit "s" for
my notes), but even with the speaker notes there's a lot missing, since I mostly knew what I wanted
to say without any notes.

A few folks have asked me about this presentation or the hiring process I've followed, so I thought
it would be good to write it up. This is the process we used at [MaxMind][3], and I plan to do
something largely similar in the future here at [ActiveState][4]. Nothing in here is particularly
novel or super secret, so I'm not giving away any insider info.

## Figure Out What You Want as a Team

The hiring process starts before you receive any resumes! Step one is to get everyone involved in
the hiring to agree on what you want. And I'm not talking about the job title, I'm talking about how
you will evaluate the candidate. You can think of this in terms of something like a user story ...

> We want to hire a developer to work on our back-end systems, including REST APIs and batch
> processing systems. We are also looking for someone to help lead the introduction of Dev Ops
> deployment and CI tools. The systems are written in a mix of Shell, Befunge, and Ook. We have a
> number of developers with expertise in these languages and can train someone on this, but
> experience with REST APIs and batch processing is important. Experience with Dev Ops tools like
> Ansible or Puppet would be very helpful.
>
> This developer will work closely with front-end developers and product management to coordinate on
> new features and bug fixes. They will also work with sales in a sales engineering role to
> understand customer requests and help sales scope quotes for implementation of these requests.

You don't have to actually write this out, but you see the idea. From this write up the hiring team
can get a sense of what we're looking for. We want someone with strong back-end development skills
who we think can learn unusual languages quickly. They should have experience on web apps. They also
need excellent communication skills and have to be able to work productively with non-technical
people. Finally, they should also bring Dev Ops skills to the company.

There's no mention of domain knowledge, so presumably we think we can teach this person what they
need to know in that regard.

## The Job Posting

Great, now we have a sense of what we're looking for. The posting should, as much as possible, be
specific. Tell people what exactly they're working on, exactly what skills are **required**
versus **optional**, etc.

**I strongly favor putting a salary range in the job posting.** Salary ranges in development are all
over the place. Let's not waste each other's time.

In the job description, provide details about the technologies you use, your development practices,
and about the rest of the team they'll be working with. Don't just say "it's a great place to work."
**Be specific!** This is an opportunity to convince good people to apply. Generic platitudes of
"doing excellent work" and "valuing teamwork" don't cut it.

I also always say that a cover letter is required. See below for details.

## Application Screening

Since we require a cover letter we can throw out any application without one. If an applicant cannot
read the three sentences of the "How to Apply" section and follow directions, I don't think they can
be successful as a developer. People who care about this particular job will get this right. In
other words, one of  my evaluation criteria for candidates is "must be able to read and follow
incredibly trivial instructions".

Ideally, screening starts with a recruiter or HR person who screens for the basics (cover letter,
work permit, etc.). Then you can have a few (2-4) people from the hiring team give a thumbs up/down
to each application. If there's a mix of yes and no I'm inclined to say no. In the past I've done
"yes/no/maybe" where "maybe" means "I lean towards no but if someone else feels strongly let's move
forward". I'm not sure how useful that was, since there's nothing stopping any reviewer for
advocating that an applicant be reconsidered by others even if they give a "no".

But if you cannot all agree to move forward with an applicant, don't. If the position is decent,
you'll have lots of applications, so filtering is important.

When screening, I read the cover letter and resume for basic English proficiency. Written
communication skills are important for almost every professional job, and development is no
exception. I'm interested in clarity, basic grammar, etc. It doesn't need to be perfect or
beautiful, just competent and clear. The same goes for the resume. I'm mostly interested in seeing
that it's not gibberish and that they have done at least something of interest. And of course, there
are the obvious red flags like having worked 10 jobs in 5 years.

If there are specific skills that we need, I look for those as well. Note that sometimes people
mention this in the cover letter but it's not obvious on the resume. That's okay. Sometimes it's
hard to put everything you want into your resume without making a mess.

Doing an initial phone screen before moving to the homework is a good idea. This should be a short
(15-30 minutes) interview with just a few questions. This can be done by an HR person or recruiter.
Consider this a basic sanity screening. Some people look good on paper but when you talk to them you
discover they are incoherent or full of rage or totally disorganized or in some other way not a good
hire. This can be a good time saver since the following steps require a greater time investment from
multiple people.

## Homework

I very firmly believe that you cannot hire developers without actually seeing their code.
Specifically, you must see a non-trivial piece of work, not just a few lines of code whipped up in
an interview. Asking people to write significant amounts of code in an interview is evil, so that's
right out. While some people have significant bodies of code available in public, many don't. Thus
the homework.

Let's get the first objection out of the way. How can I ask someone to spend 2-3 hours of their free
time doing "work"?! The outrage!

The homework should never be something you actually want to use. That is totally unacceptable (and
stupid, since it probably opens you up to all sorts of legal issues if you use this code). Second, I
don't understand why some folks object to homework but gladly fly somewhere to spend all day in
interviews. This occupies **way** more of your time than a homework exercise but is considered
entirely acceptable in our industry.

The homework should be a non-trivial exercise that produces at least a few hundred lines of code,
ideally spread across 2+ modules/classes/whatever. Here's the [homework we used at MaxMind][5]. Note
that just like with our overall candidate screening, this includes a [clear set of evaluation
criteria][6]. You need to have this before you send the homework.

Two people reviewing the homework is enough, even if more will be involved in the following
interviews. Reviewing the homework is time intensive. Since we have evaluation criteria for the
homework, we should not expect different people to come up with radically different evaluations.

Expect some attrition during this part of the process. Some people will simply never complete the
homework. This is expected.

## Interview #1

I'm a fan of fewer interviews with more people. This is a good time saver and gets candidates
through the pipeline quickly. However, if you have multiple people in an interview, make sure you
all agree on who will talk when. Interviewing is uncomfortable for most applicants, and having the
interviewers talk over each other and otherwise being disorganized makes this discomfort worse. It's
okay to have one person do the bulk of the talking. It's also okay to hand off between interviewers.

I also like to assign a note-taker who records the person's responses. This can be handy to refer to
when discussing them later.

For the first interview, I typically have all the developers/sysadmins/whatever present who are
participating, which should be 2-3 people, plus their manager (which in my new position at
ActiveState is me).

Start the interview with introductions from all people present. Then try to set the tone by
explaining the plan for the interview in terms of what types of questions you'll be asking, your
goals for the interview, and when they will be able to ask questions (which you **must** allow a
non-trivial amount of time for).

You should have a list of interview questions that you use for all candidates. However, you can
adjust these as needed to fit each applicant, for example skipping things that you already know from
the resume, or digging into a particular past work experience. All the questions should tie back to
the overall evaluation criteria. Don't ask questions with no purpose!

**Do**, however, start off with some softball questions. I usually ask something like "what
interests you about this position?" to start. This **should** be an easy question for the candidate
to answer. If it's not, that is a red flag.

I've already written quite a bit about [tech interviews][7] in the past. Read that blog post for
more details on some questions to ask and what I think I can learn from them.

I expect this interview to take 60-90 minutes, with at least 15 minutes for the candidate to ask
questions. I ask the interviewers to stay on afterwards for a brief debrief as well.

## Post-Interview Evaluation

In the past, I've done this as a spreadsheet where everyone enters in a rating from 1-4 on a variety
of weighted categories. This produced a numeric rating from each interview and an average rating.

**I'm really not sure this was worth the effort!** Some alternatives that I would consider now ...

- Just have everyone provide a thumbs up/down vote with a short write-up of why. If this is not
  unanimous, get together and discuss it.
- After the interview, go through a list of criteria and have everyone share their rating from 1-4
  (if you're on a video call, they can hold up fingers). Discuss differences and reach consensus,
  then record this in a spreadsheet as "the" rating (kind of like doing planning poker).

My feeling after having done many, many interviews is that trying to make this process too
scientific won't achieve much. What generally happens is either that everyone agrees the candidate
is awesome, agrees that they're *not* awesome, or is ambivalent. It's incredibly rare to have people
divided on awesome versus not awesome, so attempting to tease out degrees of good vs bad with
numeric ratings may not achieve much.

Of course, the other thing recorded ratings can provide is a way to compare candidates. If two
candidates were both awesome, how do you figure out which is more awesome? Again, in my experience
this has never been that difficult, and we were always able to come up with a ranking by order of
preference through a quick discussion.

## Pairing Session

If the interview went well the next step is a pairing session with **one person** from the first
interview\*\* **. What can we pair on? Hey, remember that homework? This is a great opportunity to
do work closely with an applicant in the least non-threatening way I can think of. Instead of
throwing some new problem at them, **you're working on code they wrote!\*\* How perfect is that?

If you spotted any bugs in their code when reviewing it, that's a good place to start. You could
also add some new tests, add a feature, etc. Just make sure that whatever you pick to work on is
something you can do in 60-90 minutes. This is not the place to turn a simple command line tool into
a distributed service with an SPA front-end powered by a REST API.

## More Interviews

All that's left is any remaining interviews. At companies that don't suck, this means that the next
step up the management chain should interview the applicant. For my team at ActiveState, this would
be our VP of Engineering.

At small companies (less than I dunno, say 50-100 people), the CEO will often want to interview
everyone too. If you think that the CEO is micro-managing here, you are wrong. The CEO is ultimately
responsible for everything the company does, so of course they want to talk to potential new hires.
This is also a **fantastic** opportunity for the applicant. At well-run companies, the CEO is very
important in determining the day-to-day experience of all employees. If you object to the CEO
interviewing candidates, your problems are larger than the interviewing process. Maybe it's time to
start applying for a new job yourself?

However, if your upper-level management (VPE, CEO, etc.) is **vetoing** your hires often, **then you
have a problem**. If someone gets to this last stage, that should mean that everyone agrees that
they meet (or ideally exceed) the criteria you're looking for. Frequent vetoes mean that not
everyone agrees. Talk with upper management and figure out what's going wrong. You may need to start
the whole hiring process over from the beginning to get on the same page. Fortunately, I've never
experienced this.

## What Am I Leaving Out?

One thing I haven't touched on is how eliminating bias in the hiring process. I don't have a lot of
experience on this, so I'd love to learn more. Tell me about this in the comments!

There are probably lots of other things I'm forgetting to mention. If you have further questions,
leave them in the comments and I will respond there or in another blog post.

[1]: http://www.perlconference.us/tpc-2017-dc/
[2]: https://www.houseabsolute.com/presentations/github/technical-hiring/#/
[3]: https://www.maxmind.com/
[4]: https://www.activestate.com/
[5]: https://github.com/autarch/dev-hire-homework
[6]: https://github.com/autarch/dev-hire-homework/blob/master/EVALUATION.md
[7]: https://blog.urth.org/2016/03/08/tech-interviewer-theory/

## Comments

**Mark Fowler, on 2017-07-15 07:38, said:**  
You're missing the part where you establish at the end of each stage when the candidate will hear
back from you and how important it is to stay engaged with the candidate throughout the interview
process with any timeframes they may have. You don't want your potential hire to think you've
silently rejected them when you're just going though some internal process or waiting for Carl to
return from vacation so you can sign off on hiring them. This, obviously, is also respectful to the
candidate and shows you value their time and needs, and gives you a chance to avoid accidentally not
getting your offer in in time when your desirable candidate is presumably also interviewing
elsewhere.

You're also missing some minor details of the nitty gritty of the interview process:

- Conducting some of all stages of interviews via video conference when possible makes the process
  less onerous on the candidate, especially if it involves flying in.
- Having some backup plan for reaching the interviewee if the videoconferencing software fails (a
  backup telephone number) is a good idea (google meet et al can also provide dial in telephone
  numbers, the video conference can often dial out). Remember it's much harder for the candidate if
  they can't see who is talking though - they're not familiar with everyone's voice

**Ed, on 2017-07-17 01:39, said:**  
Nice article and nice process

Mark is 100% correct. You will generate more applications and a lot more good will by being
transparent about the steps and timeline of your hiring process. This is also good as being public
about how long it will take you to make a decision at each step keeps your team disciplined.

Two other things I think you're missing:

1. Be very clear from the first job posting about who is legally eligible for the job. Are you
   willing to sponsor a work permit, etc? If not, say so clearly and don't waste everyone's time

2. Hiring doesn't end with the offer. It ends at the end of the probation period. So it's critical
   to have a training and on-boarding plan for the new employee, and make sure they have computer,
   etc ready to go on the day they join. Above all a plan for the first few weeks and months of how
   they will learn your systems, what their first projects will be, etc to ensure they are rapidly
   contributing and thriving.

**Kevin Centeno, on 2017-07-17 09:01, said:**  
On pairing as the interviewer:

1. I find it helpful to say something like "If you run into any issues, I can be your Google" or if
   you notice the candidate getting stuck on something, say "Oh yeah, I keep forgetting how to write
   a for loop, reverse a string, etc etc. One sec, let me Google that". It shows a bit of humanity
   and humility, and helps with the incredible candidate awkwardness of pairing with someone you
   just met... who also has a say in your hiring... and could potentially be your colleague in the
   near future.

2. There's a solid chance the candidate will sit there silently, thinking over the problem.
   Encourage the candidate to think aloud. They might say they need a moment, and sure, give it to
   them. But the longer the quiet continues, the more pressure builds. Ask them a question like
   "What options are you going over in your head?". Gently remind them that this isn't going out to
   production, so we're not looking for perfect; we're more interested on thought process and
   communication. One of the best candidates I've ever interviewed got absolutely flustered at the
   pairing because she forgot some syntax. We ended up just writing pseudo code for 3 approaches...
   and admittedly, I didn't even think of 2 of the approaches.

3. If the candidate is doing well, press them. Not a lot of people do this, some people think this
   is bad. But for me, I want to see how far a candidate can go, and how they handle themselves when
   they reach their limit. I'm not saying be a jerk or ask them to solve some unsolved math theorem,
   but be prepared for a candidate to do really well on the happy path by pressing with the not so
   happy path. You have 90-ish minutes to decide if you want to work with someone for next few
   months or maybe years. They might be your manager some day. Wouldn't you want to know if they're
   the type to rage quit, or if they're the type to admit that they don't know the answer and ask
   for help?

After the candidate starts working:

Always have a hiring process review with your new colleague. Did they enjoy the hiring process? Did
they hate the hiring process? What should we keep doing in future interviews? What should we stop
doing in future interviews?

On eliminating bias:

Super hard. Things that come to mind are: rotate interviewers, ensure that your interview questions
are inclusive, and question hiring decisions. Even go as far question general company policies: are
we an inclusive company right now? Do we have the infrastructure or even the attitude to support the
growth of our current and future employees? How do we handle conflict? How do we encourage
discussion? How do we build consensus? How do we keep ourselves accountable?
