---
title: A Technical Hiring Process
author: Dave Rolsky
type: post
date: 2017-07-14T19:34:36+00:00
url: /2017/07/14/a-technical-hiring-process/
categories:
  - Uncategorized

---
At [The Perl Conference 2017][1], I gave a talk titled _How to Make Your Technical Hiring Process Suck at Least 20% Less_. A Bold goal, I know!

Unfortunately, the video from that talk did not come out. The [slides are available][2] (hit &#8220;s&#8221; for my notes), but even with the speaker notes there&#8217;s a lot missing, since I mostly knew what I wanted to say without any notes.

A few folks have asked me about this presentation or the hiring process I&#8217;ve followed, so I thought it would be good to write it up. This is the process we used at [MaxMind][3], and I plan to do something largely similar in the future here at [ActiveState][4]. Nothing in here is particularly novel or super secret, so I&#8217;m not giving away any insider info.

## Figure Out What You Want as a Team

The hiring process starts before you receive any resumes! Step one is to get everyone involved in the hiring to agree on what you want. And I&#8217;m not talking about the job title, I&#8217;m talking about how you will evaluate the candidate. You can think of this in terms of something like a user story &#8230;

> <p style="text-align: left;">
>   We want to hire a developer to work on our back-end systems, including REST APIs and batch processing systems. We are also looking for someone to help lead the introduction of Dev Ops deployment and CI tools. The systems are written in a mix of Shell, Befunge, and Ook. We have a number of developers with expertise in these languages and can train someone on this, but experience with REST APIs and batch processing is important. Experience with Dev Ops tools like Ansible or Puppet would be very helpful.
> </p>
> 
> <p style="text-align: left;">
>   This developer will work closely with front-end developers and product management to coordinate on new features and bug fixes. They will also work with sales in a sales engineering role to understand customer requests and help sales scope quotes for implementation of these requests.
> </p>

You don&#8217;t have to actually write this out, but you see the idea. From this write up the hiring team can get a sense of what we&#8217;re looking for. We want someone with strong back-end development skills who we think can learn unusual languages quickly. They should have experience on web apps. They also need excellent communication skills and have to be able to work productively with non-technical people. Finally, they should also bring Dev Ops skills to the company.

There&#8217;s no mention of domain knowledge, so presumably we think we can teach this person what they need to know in that regard.

## The Job Posting

Great, now we have a sense of what we&#8217;re looking for. The posting should, as much as possible, be specific. Tell people what exactly they&#8217;re working on, exactly what skills are **required** versus **optional**, etc.

**I strongly favor putting a salary range in the job posting.** Salary ranges in development are all over the place. Let&#8217;s not waste each other&#8217;s time.

In the job description, provide details about the technologies you use, your development practices, and about the rest of the team they&#8217;ll be working with. Don&#8217;t just say &#8220;it&#8217;s a great place to work.&#8221; **Be specific!** This is an opportunity to convince good people to apply. Generic platitudes of &#8220;doing excellent work&#8221; and &#8220;valuing teamwork&#8221; don&#8217;t cut it.

I also always say that a cover letter is required. See below for details.

## Application Screening

Since we require a cover letter we can throw out any application without one. If an applicant cannot read the three sentences of the &#8220;How to Apply&#8221; section and follow directions, I don&#8217;t think they can be successful as a developer. People who care about this particular job will get this right. In other words, one of  my evaluation criteria for candidates is &#8220;must be able to read and follow incredibly trivial instructions&#8221;.

Ideally, screening starts with a recruiter or HR person who screens for the basics (cover letter, work permit, etc.). Then you can have a few (2-4) people from the hiring team give a thumbs up/down to each application. If there&#8217;s a mix of yes and no I&#8217;m inclined to say no. In the past I&#8217;ve done &#8220;yes/no/maybe&#8221; where &#8220;maybe&#8221; means &#8220;I lean towards no but if someone else feels strongly let&#8217;s move forward&#8221;. I&#8217;m not sure how useful that was, since there&#8217;s nothing stopping any reviewer for advocating that an applicant be reconsidered by others even if they give a &#8220;no&#8221;.

But if you cannot all agree to move forward with an applicant, don&#8217;t. If the position is decent, you&#8217;ll have lots of applications, so filtering is important.

When screening, I read the cover letter and resume for basic English proficiency. Written communication skills are important for almost every professional job, and development is no exception. I&#8217;m interested in clarity, basic grammar, etc. It doesn&#8217;t need to be perfect or beautiful, just competent and clear. The same goes for the resume. I&#8217;m mostly interested in seeing that it&#8217;s not gibberish and that they have done at least something of interest. And of course, there are the obvious red flags like having worked 10 jobs in 5 years.

If there are specific skills that we need, I look for those as well. Note that sometimes people mention this in the cover letter but it&#8217;s not obvious on the resume. That&#8217;s okay. Sometimes it&#8217;s hard to put everything you want into your resume without making a mess.

Doing an initial phone screen before moving to the homework is a good idea. This should be a short (15-30 minutes) interview with just a few questions. This can be done by an HR person or recruiter. Consider this a basic sanity screening. Some people look good on paper but when you talk to them you discover they are incoherent or full of rage or totally disorganized or in some other way not a good hire. This can be a good time saver since the following steps require a greater time investment from multiple people.

## Homework

I very firmly believe that you cannot hire developers without actually seeing their code. Specifically, you must see a non-trivial piece of work, not just a few lines of code whipped up in an interview. Asking people to write significant amounts of code in an interview is evil, so that&#8217;s right out. While some people have significant bodies of code available in public, many don&#8217;t. Thus the homework.

Let&#8217;s get the first objection out of the way. How can I ask someone to spend 2-3 hours of their free time doing &#8220;work&#8221;?! The outrage!

The homework should never be something you actually want to use. That is totally unacceptable (and stupid, since it probably opens you up to all sorts of legal issues if you use this code). Second, I don&#8217;t understand why some folks object to homework but gladly fly somewhere to spend all day in interviews. This occupies **way** more of your time than a homework exercise but is considered entirely acceptable in our industry.

The homework should be a non-trivial exercise that produces at least a few hundred lines of code, ideally spread across 2+ modules/classes/whatever. Here&#8217;s the [homework we used at MaxMind][5]. Note that just like with our overall candidate screening, this includes a [clear set of evaluation criteria][6]. You need to have this before you send the homework.

Two people reviewing the homework is enough, even if more will be involved in the following interviews. Reviewing the homework is time intensive. Since we have evaluation criteria for the homework, we should not expect different people to come up with radically different evaluations.

Expect some attrition during this part of the process. Some people will simply never complete the homework. This is expected.

## Interview #1

I&#8217;m a fan of fewer interviews with more people. This is a good time saver and gets candidates through the pipeline quickly. However, if you have multiple people in an interview, make sure you all agree on who will talk when. Interviewing is uncomfortable for most applicants, and having the interviewers talk over each other and otherwise being disorganized makes this discomfort worse. It&#8217;s okay to have one person do the bulk of the talking. It&#8217;s also okay to hand off between interviewers.

I also like to assign a note-taker who records the person&#8217;s responses. This can be handy to refer to when discussing them later.

For the first interview, I typically have all the developers/sysadmins/whatever present who are participating, which should be 2-3 people, plus their manager (which in my new position at ActiveState is me).

Start the interview with introductions from all people present. Then try to set the tone by explaining the plan for the interview in terms of what types of questions you&#8217;ll be asking, your goals for the interview, and when they will be able to ask questions (which you **must** allow a non-trivial amount of time for).

You should have a list of interview questions that you use for all candidates. However, you can adjust these as needed to fit each applicant, for example skipping things that you already know from the resume, or digging into a particular past work experience. All the questions should tie back to the overall evaluation criteria. Don&#8217;t ask questions with no purpose!

**Do**, however, start off with some softball questions. I usually ask something like &#8220;what interests you about this position?&#8221; to start. This **should** be an easy question for the candidate to answer. If it&#8217;s not, that is a red flag.

I&#8217;ve already written quite a bit about [tech interviews][7] in the past. Read that blog post for more details on some questions to ask and what I think I can learn from them.

I expect this interview to take 60-90 minutes, with at least 15 minutes for the candidate to ask questions. I ask the interviewers to stay on afterwards for a brief debrief as well.

## Post-Interview Evaluation

In the past, I&#8217;ve done this as a spreadsheet where everyone enters in a rating from 1-4 on a variety of weighted categories. This produced a numeric rating from each interview and an average rating.

**I&#8217;m really not sure this was worth the effort!** Some alternatives that I would consider now &#8230;

  * Just have everyone provide a thumbs up/down vote with a short write-up of why. If this is not unanimous, get together and discuss it.
  * After the interview, go through a list of criteria and have everyone share their rating from 1-4 (if you&#8217;re on a video call, they can hold up fingers). Discuss differences and reach consensus, then record this in a spreadsheet as &#8220;the&#8221; rating (kind of like doing planning poker).

My feeling after having done many, many interviews is that trying to make this process too scientific won&#8217;t achieve much. What generally happens is either that everyone agrees the candidate is awesome, agrees that they&#8217;re _not_ awesome, or is ambivalent. It&#8217;s incredibly rare to have people divided on awesome versus not awesome, so attempting to tease out degrees of good vs bad with numeric ratings may not achieve much.

Of course, the other thing recorded ratings can provide is a way to compare candidates. If two candidates were both awesome, how do you figure out which is more awesome? Again, in my experience this has never been that difficult, and we were always able to come up with a ranking by order of preference through a quick discussion.

## Pairing Session

If the interview went well the next step is a pairing session with **one person** from the first interview** **. What can we pair on? Hey, remember that homework? This is a great opportunity to do work closely with an applicant in the least non-threatening way I can think of. Instead of throwing some new problem at them, **you&#8217;re working on code they wrote!** How perfect is that?

If you spotted any bugs in their code when reviewing it, that&#8217;s a good place to start. You could also add some new tests, add a feature, etc. Just make sure that whatever you pick to work on is something you can do in 60-90 minutes. This is not the place to turn a simple command line tool into a distributed service with an SPA front-end powered by a REST API.

## More Interviews

All that&#8217;s left is any remaining interviews. At companies that don&#8217;t suck, this means that the next step up the management chain should interview the applicant. For my team at ActiveState, this would be our VP of Engineering.

At small companies (less than I dunno, say 50-100 people), the CEO will often want to interview everyone too. If you think that the CEO is micro-managing here, you are wrong. The CEO is ultimately responsible for everything the company does, so of course they want to talk to potential new hires. This is also a **fantastic** opportunity for the applicant. At well-run companies, the CEO is very important in determining the day-to-day experience of all employees. If you object to the CEO interviewing candidates, your problems are larger than the interviewing process. Maybe it&#8217;s time to start applying for a new job yourself?

However, if your upper-level management (VPE, CEO, etc.) is **vetoing** your hires often, **then you have a problem**. If someone gets to this last stage, that should mean that everyone agrees that they meet (or ideally exceed) the criteria you&#8217;re looking for. Frequent vetoes mean that not everyone agrees. Talk with upper management and figure out what&#8217;s going wrong. You may need to start the whole hiring process over from the beginning to get on the same page. Fortunately, I&#8217;ve never experienced this.

## What Am I Leaving Out?

One thing I haven&#8217;t touched on is how eliminating bias in the hiring process. I don&#8217;t have a lot of experience on this, so I&#8217;d love to learn more. Tell me about this in the comments!

There are probably lots of other things I&#8217;m forgetting to mention. If you have further questions, leave them in the comments and I will respond there or in another blog post.

 [1]: http://www.perlconference.us/tpc-2017-dc/
 [2]: https://www.houseabsolute.com/presentations/github/technical-hiring/#/
 [3]: https://www.maxmind.com/
 [4]: https://www.activestate.com/
 [5]: https://github.com/autarch/dev-hire-homework
 [6]: https://github.com/autarch/dev-hire-homework/blob/master/EVALUATION.md
 [7]: https://blog.urth.org/2016/03/08/tech-interviewer-theory/

## Comments

### Comment by Mark Fowler on 2017-07-15 07:38:06 -0500
You&#8217;re missing the part where you establish at the end of each stage when the candidate will hear back from you and how important it is to stay engaged with the candidate throughout the interview process with any timeframes they may have. You don&#8217;t want your potential hire to think you&#8217;ve silently rejected them when you&#8217;re just going though some internal process or waiting for Carl to return from vacation so you can sign off on hiring them. This, obviously, is also respectful to the candidate and shows you value their time and needs, and gives you a chance to avoid accidentally not getting your offer in in time when your desirable candidate is presumably also interviewing elsewhere. 

You&#8217;re also missing some minor details of the nitty gritty of the interview process:

* Conducting some of all stages of interviews via video conference when possible makes the process less onerous on the candidate, especially if it involves flying in.  
* Having some backup plan for reaching the interviewee if the videoconferencing software fails (a backup telephone number) is a good idea (google meet et al can also provide dial in telephone numbers, the video conference can often dial out). Remember it&#8217;s much harder for the candidate if they can&#8217;t see who is talking though &#8211; they&#8217;re not familiar with everyone&#8217;s voice

### Comment by Ed on 2017-07-17 01:39:14 -0500
Nice article and nice process

Mark is 100% correct. You will generate more applications and a lot more good will by being transparent about the steps and timeline of your hiring process. This is also good as being public about how long it will take you to make a decision at each step keeps your team disciplined.

Two other things I think you&#8217;re missing:

1. Be very clear from the first job posting about who is legally eligible for the job. Are you willing to sponsor a work permit, etc? If not, say so clearly and don&#8217;t waste everyone&#8217;s time

2. Hiring doesn&#8217;t end with the offer. It ends at the end of the probation period. So it&#8217;s critical to have a training and on-boarding plan for the new employee, and make sure they have computer, etc ready to go on the day they join. Above all a plan for the first few weeks and months of how they will learn your systems, what their first projects will be, etc to ensure they are rapidly contributing and thriving.

### Comment by Kevin Centeno on 2017-07-17 09:01:03 -0500
On pairing as the interviewer:

1. I find it helpful to say something like &#8220;If you run into any issues, I can be your Google&#8221; or if you notice the candidate getting stuck on something, say &#8220;Oh yeah, I keep forgetting how to write a for loop, reverse a string, etc etc. One sec, let me Google that&#8221;. It shows a bit of humanity and humility, and helps with the incredible candidate awkwardness of pairing with someone you just met&#8230; who also has a say in your hiring&#8230; and could potentially be your colleague in the near future.

2. There&#8217;s a solid chance the candidate will sit there silently, thinking over the problem. Encourage the candidate to think aloud. They might say they need a moment, and sure, give it to them. But the longer the quiet continues, the more pressure builds. Ask them a question like &#8220;What options are you going over in your head?&#8221;. Gently remind them that this isn&#8217;t going out to production, so we&#8217;re not looking for perfect; we&#8217;re more interested on thought process and communication. One of the best candidates I&#8217;ve ever interviewed got absolutely flustered at the pairing because she forgot some syntax. We ended up just writing pseudo code for 3 approaches&#8230; and admittedly, I didn&#8217;t even think of 2 of the approaches.

3. If the candidate is doing well, press them. Not a lot of people do this, some people think this is bad. But for me, I want to see how far a candidate can go, and how they handle themselves when they reach their limit. I&#8217;m not saying be a jerk or ask them to solve some unsolved math theorem, but be prepared for a candidate to do really well on the happy path by pressing with the not so happy path. You have 90-ish minutes to decide if you want to work with someone for next few months or maybe years. They might be your manager some day. Wouldn&#8217;t you want to know if they&#8217;re the type to rage quit, or if they&#8217;re the type to admit that they don&#8217;t know the answer and ask for help?

After the candidate starts working:

Always have a hiring process review with your new colleague. Did they enjoy the hiring process? Did they hate the hiring process? What should we keep doing in future interviews? What should we stop doing in future interviews?

On eliminating bias:

Super hard. Things that come to mind are: rotate interviewers, ensure that your interview questions are inclusive, and question hiring decisions. Even go as far question general company policies: are we an inclusive company right now? Do we have the infrastructure or even the attitude to support the growth of our current and future employees? How do we handle conflict? How do we encourage discussion? How do we build consensus? How do we keep ourselves accountable?