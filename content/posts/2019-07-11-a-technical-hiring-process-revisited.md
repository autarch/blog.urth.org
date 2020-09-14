---
title: A Technical Hiring Process Revisited
author: Dave Rolsky
type: post
date: 2019-07-11T18:45:16+00:00
url: /2019/07/11/a-technical-hiring-process-revisited/
categories:
  - Uncategorized

---
**Hey,** [**ActiveState is hiring many people, and all of our engineering positions are remote-friendly!**][1] **If you like what I say here,** [**maybe you&#8217;d like to apply for one of those positions**][2]**?**

Two years ago I wrote a post based on a talk I gave at [The Perl Conference 2017][3] titled&nbsp;_How to Make Your Technical Hiring Process Suck at Least 20% Less_. The video recording for that talk never worked out. However, in 2018 [I gave the talk again and it was recorded][4].

Since then I&#8217;ve done a fair bit more [hiring at ActiveState][2], my current employer, and I wanted to update that post with some things I&#8217;ve learned. There were also some great comments on the first version of this post and I&#8217;m going to incorporate some of those here as well.

So while some of this is copied more or less verbatim from the [first version of this post][5], I hope there&#8217;s enough new content to make it worth your time to keep reading.

## Some Tenets of the Process

  1. **Treat candidates humanely and respectfully.** Don&#8217;t ask trick questions. Don&#8217;t demand too much of their time. Reject them quickly rather than stringing them along so they don&#8217;t waste time or mental energy on a position they will never get.
  2. **Communicate more rather than less.** Make sure the candidate always knows where they are in the process, what to expect, and what the timeline will be for hearing back from you. If something changes tell them as soon as you can.
  3. **Hiring should be your number one priority when you&#8217;re doing it.** This means moving other meetings and being willing to do interviews at odd hours (nights and weekends) when necessary.
  4. **Be flexible about your process.** If you need to do your interviews in a different order than I suggest to accommodate everyone&#8217;s schedule, that&#8217;s much better than making the process take longer for a great candidate.

## Figure Out What You Want as a Team

The hiring process starts before you receive any resumes! Step one is to get everyone involved in the hiring to agree on what you want. And I&#8217;m not talking about the job title, I&#8217;m talking about how you will evaluate the candidate. You can think of this in terms of something like a user story …

<blockquote class="wp-block-quote is-style-default">
  <p>
    We want to hire a developer to work on our back-end systems, including REST APIs and batch processing systems. We are also looking for someone to help lead the introduction of Dev Ops deployment and CI tools. The systems are written in a mix of Shell, Befunge, and Ook. We have a number of developers with expertise in these languages and can train someone on this, but experience with REST APIs and batch processing is important. Experience with Dev Ops tools like Ansible or Puppet would be very helpful.
  </p>
  
  <p>
    This developer will work closely with front-end developers and product management to coordinate on new features and bug fixes. They will also work with sales in a sales engineering role to understand customer requests and help sales scope quotes for implementation of these requests.
  </p>
</blockquote>

You don&#8217;t have to actually write this out, but you see the idea. From this write up the hiring team can get a sense of what we&#8217;re looking for. We want someone with strong back-end development skills who we think can learn unusual languages quickly. They should have experience on web apps. They also need excellent communication skills and have to be able to work productively with non-technical people. Finally, if they can bring Dev Ops skills to the company that would be a big plus.

There&#8217;s no mention of domain knowledge, so presumably we think we can teach this person what they need to know in that regard.

## The Job Posting

Great, now we have a sense of what we&#8217;re looking for. The posting should, as much as possible, be specific. Tell people what exactly they&#8217;re working on, exactly what skills are&nbsp;**required** versus&nbsp;**optional**, etc.

**I strongly favor putting a salary range in the job posting.**&nbsp;Salary ranges for technical positions are all over the place. Let&#8217;s not waste each other&#8217;s time.

Management always hates this for a variety of reasons I don&#8217;t agree with. I lost this battle at ActiveState, though I know our salaries are good.

[Ed Freyfogle][6] raised a great point in the comments after my first version of this post. **Make sure your posting clearly explains what types of candidates you will consider.** Do they have to work in an office (or one of several offices)? Do they need to already be eligible to work in a certain country? Will you sponsor candidates for a work visa? Are you open to working with someone as a long-term B2B contractor? Maybe you&#8217;ll hire from anywhere but you expect all staff to work on North American or Japanese hours. Make sure you say all of that!

In the job description, provide details about the technologies you use, your development practices, and about the rest of the team they&#8217;ll be working with. Don&#8217;t just say &#8220;it&#8217;s a great place to work.&#8221; **Be specific!** This is an opportunity to convince good people to apply. Generic platitudes of &#8220;doing excellent work&#8221; and &#8220;valuing teamwork&#8221; don&#8217;t cut it.

On the diversity and inclusion front, I&#8217;ve read some suggestions that certain types of language can discourage some people from applying. In particular, language with very aggressive words like &#8220;killer developer&#8221; or &#8220;we work hard and play hard&#8221; can discourage female candidates. I don&#8217;t know how well this is supported by research<sup class="modern-footnotes-footnote " data-mfn="1"><a href="javascript:void(0)"  data-mfn-reset>1</a></sup><span class="modern-footnotes-footnote__note" data-mfn="1">Psychology research is a sea of poorly designed, p-hacked, unreplicatable &#8220;research&#8221; published by journals that prefer novel results over good study design every time.</span> , but I can say that _I myself_ find these sorts of phrases very off-putting.

There are a [number of tools][7] that provide some help with this. You paste in your job description and they give you some writing feedback. I&#8217;m happy to say that the job descriptions I wrote for ActiveState do pretty well on this front. Try out [Kat Matfield&#8217;s free Gender Decoder for Job Ads][8] with your posting. At the very least it will give you something to think about.

I also always say that a cover letter is required. See below for details.

## Application Screening

Since we require a cover letter we can throw out any application without one. If an applicant cannot read the three sentences of the &#8220;How to Apply&#8221; section and follow directions, I don&#8217;t think they can be successful as a developer. People who care about this particular job will get this right. In other words, one of my evaluation criteria for candidates is &#8220;must be able to read and follow incredibly trivial instructions&#8221;.

Ideally, screening starts with a recruiter or HR person who screens for the basics (cover letter, work permit, etc.). Then you can have a few, but not too many, people from the hiring team give a thumbs up/down to each application. At ActiveState we assign two people to this. If there&#8217;s a mix of yes and no I&#8217;m inclined to say no. In the past I&#8217;ve done &#8220;yes/no/maybe&#8221; where &#8220;maybe&#8221; means &#8220;I lean towards no but if someone else feels strongly let&#8217;s move forward&#8221;. I&#8217;m not sure how useful that was, since there&#8217;s nothing stopping any reviewer for advocating that an applicant be reconsidered by others even if they give a &#8220;no&#8221;.

But if you cannot all agree to move forward with an applicant, don&#8217;t. If the position is decent, you&#8217;ll have lots of applications, so filtering is important.

When screening, I read the cover letter and resume for basic English proficiency. Written communication skills are important for almost every professional job, and technical positions are no exception. I&#8217;m interested in clarity, basic grammar, etc. It doesn&#8217;t need to be perfect or beautiful, just competent and clear. The same goes for the resume. I&#8217;m mostly interested in seeing that it&#8217;s not gibberish and that they have done at least something of interest. And of course, there are the obvious red flags like having worked 10 jobs in 5 years.

If there are specific skills that we need, I look for those as well. Note that sometimes people mention this in the cover letter but it&#8217;s not obvious on the resume. That&#8217;s okay. Sometimes it&#8217;s hard to put everything you want into your resume without making a mess.

If you have multiple roles open, especially across multiple teams, it&#8217;s really important to make sure the people reviewing resumes for one posting are aware of the others. There could be a candidate who&#8217;s a poor fit for the job they applied for but a great fit for another one. It&#8217;s a shame to lose them because you sent an auto-rejection. Instead, you want someone involved in recruiting for that other position to reach out to that candidate and see if they&#8217;re interested in moving their application.

## Phone Screenings

Doing an initial phone screen (or two) is always a good idea. If you have someone focused solely on recruiting they can do the first one. This is just a basic sanity and communication screening. Can the candidate answer some basic non-technical questions? Do they say anything really weird?

**However, under no circumstances should non-technical staff ever ask technical questions.** This is simply unacceptable. They don&#8217;t have the knowledge to evaluate the answer. And if you do this eventually [someone will write a really scathing blog post mocking your company][9] that will be [shared on Hacker News and everyone will make fun of you][10] and you&#8217;ll be sad.

At ActiveState we also do a short technical screening after the first non-technical screening. This is typically done by the Team Lead (your potential future manager). Note that all of our Team Leads are engineers as well as managers. This is a chance to ask some simple technical questions to make sure the candidate has the basic background we expect for the position. It&#8217;s also a good chance for the candidate to ask questions. We schedule these for 30 minutes but the questions I ask take just 5-10 minutes for most candidates (though hint hint, the best candidates give me detailed, thoughtful answers and end up closer to 10 rather than 5).

These are very quick, simple steps that let us screen out people with good resumes who turn out to have very little communication ability or technical knowledge.

## Homework

I very firmly believe that you cannot hire developers without actually seeing their code. Specifically, you must see a non-trivial piece of work, not just a few lines of code whipped up in an interview. **Asking people to write significant amounts of code in an interview is evil, so that&#8217;s right out.** While some people have significant bodies of code available in public, many don&#8217;t. Thus the homework.

Let&#8217;s get the first objection out of the way. How can I ask someone to spend 2-3 hours of their free time doing &#8220;work&#8221;?! The outrage!

The homework should never be something you actually want to use. That is totally unacceptable (and stupid, since it probably opens you up to all sorts of legal issues if you use this code). Second, I don&#8217;t understand why some folks object to homework but gladly fly somewhere to spend all day in interviews. This occupies&nbsp;**way** more of your time than a homework exercise but is considered entirely acceptable in our industry.

The homework should be a non-trivial exercise that produces at least a few hundred lines of code, ideally spread across 2+ modules/classes/whatever. Here&#8217;s the [homework we used at MaxMind][11]. Note that just like with our overall candidate screening, this includes a [clear set of evaluation criteria][12]. You need to define these criteria before you send the homework.

When you come up with a homework exercise you must have at least two (and preferably more) of your existing staff do it, including some people who were not involved in formulating the exercise. This is vital for several reasons. First, it will let you know where your instructions are unclear or insufficient. Second, it will let you know how long it _really_ takes to do the homework.

**If the homework is in a problem domain that relates to what your company does (and it should be) then you should expect in house to staff to finish it in half the time it will take a candidate.** If it takes someone on your team 3 hours to finish, it could easily take candidates 6 hours or more. This means that if you want an exercise that takes 3 hours then it should take your existing staff 90 minutes or less.

Two people reviewing the homework is enough, even if more will be involved in the following interviews. Reviewing the homework is time intensive. Since we have evaluation criteria for the homework, we should not expect different people to come up with radically different evaluations.

Expect some attrition during this part of the process. Some people will simply never complete the homework. This is expected.

### Homework Alternatives and Exemptions

Many of the best candidates will have significant portolios of open source or example projects available. Should you let them submit an existing project instead of doing the homework? At MaxMind we said &#8220;no&#8221; and at ActiveState we said &#8220;yes&#8221;. There are good arguments for both, but nowadays I lean think &#8220;yes&#8221; is the right answer. If you do allow this make sure to provide some guidelines for what qualifies. Here&#8217;s what we say for the [ActiveState homework][13]:

> #### **Requesting an Exemption**
> 
> The purpose of this assignment is to help us better understand your abilities as a software engineer. In addition, we will also use the work you produce as part of a pairing session during our hiring process.
> 
> You may already have some publicly available code which would help us on both these fronts. If you do, let us know and we will take a look. We’re looking for something with the following characteristics:
> 
>   * This must be your project, meaning that you wrote most of the code and you are the project&#8217;s primary maintainer.
>   * It should be something that is neither trivially small nor overwhelmingly large. We’re looking for something that ranges from 500-2000(ish) lines of code. Anything much smaller won’t have enough complexity for us to evaluate your engineering skill. Anything much larger is just overwhelming for us to evaluate and pair with you on.
>   * There should be something in the project that you’d like to work on during a pairing session. This could be fixing a bug, adding a small feature, doing a refactoring, adding tests, etc. We don’t have to finish this work during the session, but it should be something simple enough that we can really dig into it in the space of 90 minutes.
> 
> Please let your recruiting contact at ActiveState know if you have something you think is appropriate. We&#8217;ll get back to you promptly to let you know if it is, in which case you can skip the homework assignment entirely.

Given the attrition I&#8217;ve seen in the homework phase I think allowing these exemptions is worthwhile. You still get some code to review and pair on while saving the candidate 3 hours of their life.

## Pairing Session

If their code submission looks good then the next step is a pairing session with&nbsp;**one person**. That one person is ideally one of the people who reviewed their submission. This is a great opportunity to work closely with an applicant in the least non-threatening way I can think of. Instead of throwing some new problem at them, **you&#8217;re working on&nbsp;code they wrote!** How perfect is that?

If you spotted any bugs in their code when reviewing it, that&#8217;s a good place to start. You could also add some new tests, add a feature, etc. Just make sure that whatever you pick to work on is something you can do in 60-90 minutes. This is not the place to turn a simple command line tool into a distributed service with an SPA front-end powered by a REST API.

If they provided their own project instead of the homework then they are expected to come to the pairing session with some things to work on.

After my first version of this post, Kevin Centeno had some great feedback on these pairing sessions:

<blockquote class="wp-block-quote">
  <p>
    I&nbsp;find it helpful to say something like “If you run into any issues, I can be your Google” or if you notice the candidate getting stuck on something, say “Oh yeah, I keep forgetting how to write a for loop, reverse a string, etc etc. One sec, let me Google that”. It shows a bit of humanity and humility, and helps with the incredible candidate awkwardness of pairing with someone you just met… who also has a say in your hiring… and could potentially be your colleague in the near future.
  </p>
  
  <p>
    There’s a solid chance the candidate will sit there silently, thinking over the problem. Encourage the candidate to think aloud. They might say they need a moment, and sure, give it to them. But the longer the quiet continues, the more pressure builds. Ask them a question like “What options are you going over in your head?”. Gently remind them that this isn’t going out to production, so we’re not looking for perfect; we’re more interested in thought process and communication. One of the best candidates I’ve ever interviewed got absolutely flustered at the pairing because she forgot some syntax. We ended up just writing pseudo code for 3 approaches… and admittedly, I didn’t even think of 2 of the approaches.
  </p>
  
  <p>
    If the candidate is doing well, press them. Not a lot of people do this, some people think this is bad. But for me, I want to see how far a candidate can go, and how they handle themselves when they reach their limit. I’m not saying be a jerk or ask them to solve some unsolved math theorem, but be prepared for a candidate to do really well on the happy path by pressing with the not so happy path. You have 90-ish minutes to decide if you want to work with someone for next few months or maybe years. They might be your manager some day. Wouldn’t you want to know if they’re the type to rage quit, or if they’re the type to admit that they don’t know the answer and ask for help?
  </p>
</blockquote>

## A Longer Technical Interview

I&#8217;m a fan of fewer interviews with more people. This is a good time saver and gets candidates through the pipeline quickly. However, if you have multiple people in an interview, make sure you all agree on who will talk when. Being interviewed is uncomfortable for most people, and having the interviewers talk over each other and otherwise being disorganized makes this discomfort worse. It&#8217;s okay to have one person do the bulk of the talking. It&#8217;s also okay to hand off between interviewers.

I used to assign a note-taker who recorded the person&#8217;s responses (at least in paraphrase). I thought this might be useful later, but I&#8217;ve reconsidered. I rarely looked back at these notes. It might make sense to note a few things, but recording all their responses is a lot of (distracting) work for someone that didn&#8217;t seem to produce much value.

For this interview, I typically have a group of people closest to the position participating, which should be 2-3 people on the team you&#8217;re hiring for, plus their manager. If you have a small team you can have all of their future coworkers present and have 4 people or less that&#8217;s great. But don&#8217;t bring 10 people to an interview. That&#8217;s just weird and off-putting.

Start the interview with introductions from all people present. Then try to set the tone by explaining the plan for the interview in terms of what types of questions you&#8217;ll be asking, your goals for the interview, and when they will be able to ask questions (which you&nbsp;**must** allow a non-trivial amount of time for).

You should have a list of interview questions that you use for all candidates. However, you can adjust these as needed to fit each applicant, for example skipping things that you already know from the resume, or digging into a particular past work experience. All the questions should tie back to the overall evaluation criteria. Don&#8217;t ask questions with no purpose!

**Do**, however, start off with some softball questions. I usually ask something like &#8220;what interests you about this position?&#8221; to start. This&nbsp;**should** be an easy question for the candidate to answer. If it&#8217;s not, that is a red flag.

I&#8217;ve already written quite a bit about [tech interviews][14] in the past. Read that blog post for more details on some questions I ask and what I think I can learn from them.

I expect this interview to take 60-90 minutes, with at least 15 minutes for the candidate to ask questions. I ask the interviewers to stay on afterwards for a brief debrief as well.

## Post-Interview Evaluation

In the past, I&#8217;ve done this as a spreadsheet where everyone enters in a rating from 1-4 on a variety of weighted categories. This produced a numeric rating from each interview and an average rating.

**I&#8217;m really not sure this was worth the effort!** Some alternatives that I would consider now …

  * Just have everyone provide a thumbs up/down vote with a short write-up of why. If this is not unanimous, get together and discuss it.
  * After the interview, go through a list of criteria and have everyone share their rating from 1-4 (if you&#8217;re on a video call, they can hold up fingers). Discuss differences and reach consensus, then record this in a spreadsheet as &#8220;the&#8221; rating (kind of like doing planning poker).
  * **Or the best option** &#8211; use software that makes each person rate the candidate before seeing evaluations from others.

My feeling after having done many, many interviews is that trying to make this process too scientific won&#8217;t achieve much. What generally happens is either that everyone agrees the candidate is awesome, agrees that they&#8217;re&nbsp;_not_ awesome, or is ambivalent. It&#8217;s incredibly rare to have people divided on awesome versus not awesome, so attempting to tease out degrees of good vs bad with numeric ratings may not achieve much.

Of course, the other thing recorded ratings can provide is a way to compare candidates. If two candidates were both awesome, how do you figure out which is more awesome? Again, in my experience this has never been that difficult, and we were always able to come up with a ranking by order of preference through a quick discussion.

Note that &#8220;ambivalent&#8221; should just mean &#8220;no&#8221;. Either you&#8217;re excited about the idea of hiring this person or you&#8217;re not.

However, going through the process of creating a rubric for evaluating candidates is probably still worthwhile. Even if you don&#8217;t rate every candidate numerically across these attributes the process of discussing what you care about is valuable. It helps get everyone on the same page and just referring to the list of attributes can be useful when thinking about a candidate.

## More Interviews

All that&#8217;s left is any remaining interviews. At companies that don&#8217;t suck, this means that the next step up the management chain should interview the applicant. For my team at ActiveState, this would be our CTO.

At small companies (less than I dunno, say 50-100 people), the CEO will often want to interview everyone too. If you think that the CEO is micro-managing here, you are wrong. The CEO is ultimately responsible for everything the company does, so of course they want to talk to potential new hires. This is also a&nbsp;**fantastic** opportunity for the applicant. At well-run companies, the CEO is very important in determining the day-to-day experience of all employees. If you object to the CEO interviewing candidates, your problems are larger than the interviewing process. Maybe it&#8217;s time to start applying for a new job yourself?

**However, if your upper-level management (CTO, CEO, etc.) is&nbsp;vetoing your hires often, then you have a problem.** If someone gets to this last stage, that should mean that everyone agrees that they meet (or ideally exceed) the criteria you&#8217;re looking for. Frequent vetoes mean that not everyone agrees. Talk with upper management and figure out what&#8217;s going wrong. You may need to start the whole hiring process over from the beginning to get on the same page. Fortunately, I&#8217;ve never experienced this.

## After They Accept an Offer

You&#8217;re not done yet! [Ed Freyfogle][6] points out that &#8220;Hiring doesn’t end with the offer. It ends at the end of the probation period. So it’s critical to have a training and on-boarding plan for the new employee, and make sure they have computer, etc ready to go on the day they join. Above all a plan for the first few weeks and months of how they will learn your systems, what their first projects will be, etc to ensure they are rapidly contributing and thriving.&#8221;

Kevin Centeno says you should &#8220;[a]lways have a hiring process review with your new colleague. Did they enjoy the hiring process? Did they hate the hiring process? What should we keep doing in future interviews? What should we stop doing in future interviews?&#8221;

I&#8217;ve actually tried to take this latter point even further. For some hiring we did at ActiveState I sent out a survey to everyone who applied. We had a drawing for several Amazon gift cards to incentivize responses. But this ended up not achieving much. We had very few responses and there wasn&#8217;t a lot of concrete feedback other than one or two people who did not like doing the homework, which is not something I&#8217;m open to changing.

## Some Other Thoughts

In a comment on my first version of this blog post, Mark Fowler said, &#8220;&#8230; establish at the end of each stage when the candidate will hear back from you and how important it is to stay engaged with the candidate throughout the interview process with any timeframes they may have. You don’t want your potential hire to think you’ve silently rejected them when you’re just going though some internal process or waiting for Carl to return from vacation so you can sign off on hiring them. This, obviously, is also respectful to the candidate and shows you value their time and needs, and gives you a chance to avoid accidentally not getting your offer in in time when your desirable candidate is presumably also interviewing elsewhere.&#8221;

[Ed Freyfogle][6] also noted that telling the candidate what they should expect from you in terms of turnaround encourages your hiring team to actually meet your turnaround time goals.

Yes to this. A thousand times yes. I go over our hiring process with candidates during the technical screening I do, and I try to remember to ask them if they know what&#8217;s next after each subsequent phase. I also aim to give them a response in no more than one working day (and sooner, if possible).

Mark also brought up another excellent point. Doing interviews via video conference is much more humane than insisting on flying people out to your office. (I&#8217;d also note it&#8217;s better for the environment.) Mark goes on to note that when you do this you should make sure you have a backup plan for when the candidate cannot get the video conferencing software working. Most of these tools either allow for a call-in via phone or allow you to call out, or both. Make sure to communicate your backup plan to the candidate.

## Eliminating Bias in the Hiring Process

Bias has become a big topic in the tech industry. I wish I had some great ideas here. I did mention the language in the job posting, and I think that&#8217;s worth considering. But that seems like a small part of a much larger picture.

We&#8217;ve talked about this a bit when we&#8217;ve been hiring at ActiveState but haven&#8217;t come up with any great ideas. Even with what the analysis tools tell me are fairly gender-neutral job postings, we see very few applications from women. I&#8217;ve seen stats suggesting women make up anywhere from 15% to 25% of the tech work force, but they&#8217;re not even close to 15% of our applicants. The same goes for any other under-represented group that I can think of.

If we can&#8217;t even get a diverse applicant pool at the first stage of the process, any attempt at eliminating bias later in the process doesn&#8217;t matter. And yes, we&#8217;ve done the obvious things like post on job boards aimed at women. That didn&#8217;t seem to move the needle on applications at all.

I&#8217;d love some suggestions here. If you&#8217;re someone in an under-represented group in tech, what would encourage or discourage you from applying for a position? If you&#8217;ve had success in diversifying your applicant pool (and hopefully your staff as a result), how did you do it?

## Anything Else?

There are probably lots of other things I&#8217;m forgetting to mention.&nbsp;If you have further questions, leave them in the comments and I will respond there or in another blog post.

 [1]: https://blog.urth.org/2019/07/02/activestate-is-hiring-many-people/
 [2]: https://www.activestate.com/company/careers/
 [3]: http://www.perlconference.us/tpc-2017-dc/
 [4]: https://www.youtube.com/watch?v=-JzgEl782Jg&t=2s
 [5]: https://blog.urth.org/2017/07/14/a-technical-hiring-process/
 [6]: http://www.freyfogle.com/
 [7]: https://blog.ongig.com/writing-job-descriptions/diversity-tools
 [8]: http://gender-decoder.katmatfield.com/
 [9]: https://web.archive.org/web/20170914185611/http://www.gwan.com/blog/20160405.html
 [10]: https://news.ycombinator.com/item?id=12701272
 [11]: https://github.com/autarch/dev-hire-homework
 [12]: https://github.com/autarch/dev-hire-homework/blob/master/EVALUATION.md
 [13]: https://github.com/ActiveState/homework/tree/master/dep-tree
 [14]: https://blog.urth.org/2016/03/08/tech-interviewer-theory/

## Comments

### Comment by Fred Lee on 2019-07-12 13:34:13 -0500
Let me give a little &#8220;candidate&#8221; insight on your comment about &#8220;homework&#8221;.

I have passed on a few opportunities because of this requirement. My objection is the asymmetry of the investment. For a company to spend $1K flying me to their headquarters, not to mention 4-5 hours of their engineer&#8217;s time to interview me, they must be sufficiently interested in me to make that investment. I am happy to reciprocate their investment with my own time.

On the other hand it takes no investment on their part to ask me to write code for 3 hours, but it takes effort from me. Thus a company has every incentive to shotgun homework requests to every candidate whether they are really interested or not.

In other words, when a company asks me to spend a few hours writing code, I have no idea if they&#8217;re really interested in me or are simply string me along. If I were a recent college graduate or otherwise unemployed, I might be willing to make that investment. But as a gainfully employed programmer I&#8217;m just not that desperate. I find the homework request to be very disrespectful of my time, so I usually respectfully decline when those requests come in.

At the same time, I think it&#8217;s entirely reasonable to expect someone to be able to write, on a whiteboard, 20-30 lines of code (at least mostly-functional pseudo-code). I&#8217;ve found a fair number of less experienced programmers are able to modify existing code but not able to code something meaningful from scratch. I use this as a filter during interviews. I&#8217;ll ask someone to code a reasonably simple algorithm and, if they&#8217;re not able to, I&#8217;ll instead give them some code and ask them to modify it. How they respond to that situation tells me a lot about what level they may come in at.

### Comment by Dave Rolsky on 2019-07-12 14:09:39 -0500
Fred, you raise an excellent point about the asymmetric time investment of a homework exercise. I would note that reviewing someone&#8217;s homework does typically take me anywhere from 30-60 minutes, and we have 2 people do that for each submission, so it&#8217;s not zero investment on the company&#8217;s part.

But I disagree that writing 20-30 lines of (pseudo-)code on a whiteboard is at all equivalent to seeing real code of a substantial length. I think there are people who are quite capable of problem-solving with code but are not very good at designing a system. You need to give them a task that involves creating at least a few different packages and creating the interfaces between them to spot that, and you really cannot do that in a live interview.

If I could find a way to figure that out in a way that uses less of a candidate&#8217;s time, I&#8217;d adopt that strategy in a heartbeat!

### Comment by Fred Lee on 2019-07-12 14:32:06 -0500
(BTW I&#8217;m having trouble &#8220;replying to a reply&#8221; with both Chrome and Safari, thus the new post instead of nesting this under your response)  
One strategy I&#8217;ve seen, I think only once, was a company that would &#8220;hire&#8221; candidates on a contract basis for a short period of time. That way the coders were compensated for their time doing &#8220;homework&#8221;, the code could actually be used by the company if they desired, and if the contract period was successful they were brought on full-time. If there were questions, you could keep extend the contract period a bit. This also lets you evaluate a few other aspects of the candidate; how well they communicate with their &#8220;co-workers&#8221; about ambiguous requirements, how well they respond to code reviews, etc&#8230;  
I don&#8217;t recall the duration of the contract period, but I think it was perhaps a week of &#8220;part-time&#8221; work. In other words you could spend a couple hours per evening contracting. This would seem super-sketchy if it were for an unknown company, but I&#8217;d be happy to do that for a reputable company. I&#8217;m sure the payroll department didn&#8217;t love this situation of course!

### Comment by Dave Rolsky on 2019-07-12 14:52:41 -0500
Yeah, something is weird with the replies. If you switch to text mode it lets you reply. I love software.

I have brought up exactly the solution you propose but it didn&#8217;t get very far. I think the overhead for doing this can be quite a lot at some companies. I wonder if we could just offer something like an Amazon gift card, which presumably is much easier to deal with since someone at the hiring company can just buy it and expense it.

I think this would achieve the desired goal of making the costs more symmetrical for both parties. That said, this could start to get quite expensive for the hiring company if you end up rejecting a lot of candidates after seeing their homework. My experience has been that there are a fair number of people who interview quite well and produce really bad code, so I would guess rejections probably at least equal acceptances.

OTOH, if we spent $2,000-4,000 (assuming a $200 gift card) that really isn&#8217;t much if it improves our hiring throughput.

But then OTGH, people who outright refuse to do the homework have been pretty rare in my experience. And the really excellent candidates who might be most put off by the homework are more likely to have a FOSS project that they can use instead.

Anyway, it&#8217;s something to think about, for sure! Thanks again for you feedback.

### Comment by Lazaridis on 2019-07-14 16:56:48 -0500
I believe that the flaw with most hiring-processes is that &#8220;artistic-grade&#8221; or &#8220;philosophy-grade&#8221; candidates don&#8217;t even apply.

### Comment by David Hodgkinson on 2019-07-15 05:50:12 -0500
As a contractor there are three things I want to know:

What is it?  
Where is it or is it remote?  
How much are you paying?

You&#8217;d be surprised how many recruiters and companies knock themselves out at that stage. And one more thing:

Is the ad/spec literate? Is it littered with typos and not been proofread?

&nbsp;