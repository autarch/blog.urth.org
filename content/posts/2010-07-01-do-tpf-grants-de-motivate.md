---
title: Do TPF Grants De-motivate?
author: Dave Rolsky
type: post
date: 2010-07-01T17:19:33+00:00
url: /2010/07/01/do-tpf-grants-de-motivate/
---
There's been a lot of discussion about the role of TPF lately, both at YAPC and on blogs. The most recent discussion is in the comments of a [recent blog post by Gabor Szabo][1] asking people to weight in on what TPF should be doing.

In the comments, Casey West says:

> It's a striking sign that The Perl Foundation is expected to **pay for open source contributors**
> 
> ...
> 
> Right now TPF is using money to **demotivate** the Perl Community! It's killing the Perl [_sic_].

This is a bold and, in my opinion, incorrect statement.

Casey is no doubt referring to the well-known research suggesting that payment reduces performance by replacing intrinsic motivation with extrinsic motivation. Let's assume that this research is true for the sake of this blog post.

Does it necessarily follow that TPF grants reduce motivation? I don't think so. There are a number of ways grants can help people get more work done. In fact, I think there are several ways that grants can boost _intrinsic_ motivation.

## Public Promises

When a grant is approved, the recipient is promising to do something with the community's money. I can't speak for others, but I know that when my grant was approved, I had made a promise to the Perl community to follow through.

My experience with volunteers suggests that people are more likely to follow through when they make a firm commitment to someone. My understanding is that this is also backed up by modern psychological research.

I think this is one reason why regular grant reports are crucial to the grant process. This follow up makes it clear that the community is paying attention to the grant recipient.

The public nature of the grants should motivate the grant recipient. If the recipient _doesn't_ find this motivational, I don't think they should be getting a grant in the first place!

## Validation of Competence

Getting a grant can be an external validation of one's self-worth. I know that I felt good about the fact that my grant proposal got a lot of public support, and was eventually approved. Effectively, the Perl community agreed that _my_ skills were worth $3,000 of _their_ money.

I can't speak for others, but this sort of ego boost is definitely motivational for me.

## Resume Building

A successfully completed grant is a nice bit of resume building. How many developers out there have been _paid by their peers_ to work on a project? I make a point of mentioning the Moose docs grant in my bio, and I would hope that this helps sell my Moose class.

## Money = Time

One big obstacle to getting stuff done is lack of time. This is one area where a grant can help, by effectively allowing a person to take unpaid leave from a job, or a sabbatical from self-employment. In practice, most TPF grants _don't_ do this. The grants program limits grant requests to $3,000, which doesn't compensate for much time off, at least for people living in a large chunk of the world.

[David Mitchell's grants][2] are a good example of a grant that aims to provide time. His current grant pays for 500 hours of his time at $50/hour. This is probably a lot less than he could earn freelancing, but is definitely enough to allow him to live comfortably while working on the grant.

It's hard for me to see how a grant like this could be de-motivating. In this case, the grant isn't about the money per se, it's about freeing up time that would otherwise _have to be spent on paying work_.

## Forcing Me to Plan

While not directly connected to motivation, I found that the grant proposal process was very useful because it forced me to _think about my project_. [My grant proposal][3] was my project plan after the grant was approved, and it gave me a lot of direction for working on the Moose docs.

I imagine that other grant recipients also benefited from going through a planning process. I'm not sure I would have done as much thinking if I'd written the docs without having to write a proposal first.

## Summary

In my [final grant report for the Moose docs grant][4], I wrote:

> I'd like to thank the Perl Foundation again for sponsoring this work. The grant was motivational for me, because this was a huge amount of work. I might have done some of it over time, but I doubt I would have done all or done it nearly as quickly without the grant.

There are probably other ways that grants affect recipients. I'd love to hear from other grant recipients and/or submitters, either in the comments or on their own blogs.

 [1]: http://blogs.perl.org/users/gabor_szabo/2010/07/what-would-you-like-tpf-to-do.html
 [2]: http://news.perlfoundation.org/2010/02/grant-proposal-fixing-perl5-co.html
 [3]: http://news.perlfoundation.org/2008/11/2008q4_grant_proposal_moose_do.html
 [4]: /2009/04/20/moose-docs-grant-wrap-up/

## Comments

**rjbs, on 2010-07-01 19:25, said:**  
I agree with you, Dave. Casey's paragraph is either grossly misinformed or a joke. The video he cites is full of useful information that is irrelevant here. It makes the point that more money alone won't motivate all people, but the issue is that money, along with existing motivation, can facilitate action.

I find the whole comment to be disconnected from reality and personally offensive.

**Chas. Owens, on 2010-07-01 20:32, said:**  
I saw Gabor's post earlier and immediately thought "should I apply for a grant for the Perl 5 Doc Team?". I almost instantly decided no. For one thing, I want it to be a team project, and a grant to one person is antithetical to building a team. The second thing was that I don't think I need the money for anything. $3000 is about a week and a half of pay (at $50/hour) and the documentation is going take a lot more time than that, I don't need any hardware or software to do the work, and I can't think of any services it could go towards. The only thing I can think of using it for would be advertising, and I don't know what I would advertise.

**Chas. Owens, on 2010-07-01 20:40, said:**  
Whoops, it was Alberto's post.

**rjbs, on 2010-07-01 22:14, said:**  
There are definitely a lot of things for which grants aren't useful, or are even harmful. I think they're most useful to help someone prioritize and focus on a specific task that he would like to see done anyway. In my own case, I had a lot of really boring and tedious coding to do to make it possible to get back to doing fun stuff. I also had pretty slim motivation to get that work done, but other people also wanted to see it done. Accepting a grant (a) forced me to actually get it done quickly and (b) made it reasonable to spend my time doing something boring, because the income could be used to get other boring problems solved by someone else - fixing my gutters, for example. (Also imagine that while $50/hr might not pay your rates, it might pay a good babysitter, increasing your effective free time significantly - for some value of "you.")

I don't think grants make sense for every problem we want to see solved, and I think some people do not find the "I promised to do this, now I have to do it" motivation very compelling. The argument that "if you can't solve a problem for fun, the project should wither on the vine" is just bizarre.

**mirod.myopenid.com, on 2010-07-02 01:50, said:**  
You do realize that your post essentially says "There is serious research that demonstrates that grants demotivate people, but I don't believe it and here is anecdotal evidence to the contrary"?  
You list arguments that show why you think grants increase motivation, but you do not address the factors that have been shown to decrease it.

I think a useful project would be to go through the existing research in the subject and see how it applies to TPF style grants. From a cursory look at the subject there seems to be ways to mitigate the demotivating effects of extrinsic motivation. Sadly most of the papers I found online on the subject are not available for free.

Alternatives I can think of to the current system for example would be to contract establish members of the community to work on things they have no previous interest on. Like you on XML (totally random and inapropriate example of course ;-). This way the extrinsic motivation does not replace the intrinsic one. Plus you get exposure to technologies you would not necessarily learn by yourself, the community gets a fresh eye on the problem and we know from your history that you write quality code. This or any other alternative scheme (like the fix-bugs-for-a-reward scheme that Nick Clark proposed a while back) would need to be backed by studies showing why they could work.

In fact determining the best way to fund Perl development with the level of resources that TPF can access might be a good topic for an internship, or a academical study in the psychology field.

**:m), on 2010-07-02 02:33, said:**  
Money is good when cleverly spent. It helps get boring things done. It helps getting essential things done fast.  
There is the danger of envy, of course. But then we need to keep in mind that a lot of work on open source projects is sponsored by companies letting their employees spending (part of) their time on them. This is just not so obvious.

I support Gabor's grant proposal as well as it should help to fund more money. So far the amounts of grants are rather small. Compare it to GSoC. Nobody gets rich, many people get involved.  
Let's get as many people involved as possible!

**rjbs, on 2010-07-02 06:41, said:**  
The papers really don't say that. Here's a good, free paper on the subject. It's oft-cited and the authors reviewed a bunch of other papers on the topic:

<a href="http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.26.5282&#038;rep=rep1&#038;type=pdf" rel="nofollow ugc">http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.26.5282&rep=rep1&type=pdf</a>

I'm not familiar with any papers that specifically analyze the effectiveness of grant payments for skilled labor. Even the papers that I've seen on the "money as a motivator" topic don't actually indicate that money is ever a significant demotivator, just that it sometimes stops helping at some point.

**Zbigniew Lukasiak, on 2010-07-02 06:46, said:**  
In short - the grant money should not be the motivator - it should be the enabler.

**Dave Rolsky, on 2010-07-02 08:44, said:**  
@mirod: Please don't put words in my mouth. The research is more complicated than you seem to think, as rjbs points out.

The point of my post is that even if we _assume_ Casey is right, and money is entirely de-motivating, it still does not follow that grants are de-motivating.

For that to be true, a grant would have to be entirely about money and nothing else, and that's a big logical leap. That's something Casey (or you, or someone) actually has to prove, not just assert.

**Casey West, on 2010-07-02 09:15, said:**  
@rjbs says, "I find the whole comment to be disconnected from reality and personally offensive."

Apologies for causing offense. I should've elaborated on this point.

I think the video doesn't make the point I wanted to, but it does remind us that volunteer open source has been working for a long time. I don't think paying for volunteers helps very much. Here's why:

Yes, money \_may\_ motivate a grant recipient to do some work the TPF thinks the community will appreciate. I know Ricardo and Dave have done this successfully. I'm glad it worked for them. But what about all the other volunteers?

When we start paying people to do work that volunteers are also willing to do it changes the culture entirely. Why should you volunteer to sit in a booth and hawk swag for the TPF when they're paying someone to do it? That's above your pay grade. That's someone's **job**. Also, if there are no volunteers to do the work then how important is that work, really? Why must we push it with TPF grants?

Grants motivate the recipient and demotivate everyone else. TPF is valuing a small number of contributors more (and differently) than all the rest.

Now, as a measure of reality, many of us do (or have) get paid to hack on open source during our day jobs. We're paid to contribute to Open Source. Maybe what TPF is doing is just like that? I don't think it is, since there's a common belief that TPF == The Community.

As you all know this is my opinion. I don't have any empirical evidence or case studies. I do think my claim that this is "killing Perl" is over the top. Sorry about that. I forgot how sensitive we are about Perl being dead or not.

I am sorry for ruffling feathers and, if I have, for distracting us from the topic at hand.

**Dave Rolsky, on 2010-07-02 09:27, said:**  
@Casey: I think the point you make about how grants might affect people who _aren't_ the recipients is well-taken.

I suspect that this works differently for different types of grants. The existing grants program gives out small amounts of money, and the community gets a chance to weight in. In addition, the grants are on topics where the community has a lot of expertise (tech stuff), so that input is actually useful.

If the community feels a sense of ownership of the program, I'd hope that decreases any sense of de-motivation.

OTOH, we have Gabor's grant proposal, which is on something that most community members have no experience with, marketing, promotions, and fundraising. That may change the dynamic.

As far as hiring someone to do a job goes, I think their are a couple ways to avoid de-motivation. First, we can pay people to do jobs that other people don't want to, or can't, do for free. Fundraising might fall into this category. There seems to be some volunteer interest here, but not enough to really get serious about it. Paying someone to spend serious time on fundraising might get much better results.

We can also pay people to coordinate volunteers, rather than do the jobs themselves. For Gabor's grant, I'd much rather see someone paid to coordinate volunteers for booths than pay someone to staff the booth.

Ultimately, I'm not sure how we figure this out. Do we have any way to figure out whether or not the grants program is de-motivating people who don't get grants? Maybe we can contact people and do some sort of survey?

**mirod.myopenid.com, on 2010-07-02 09:28, said:**  
Dave, I was just pointing out that on a logical level, I found your post lacking. You did not deal with specific point raised by studies, or point at studies that show that TPF-style grants do work.

The little I have read on the subject of motivation, for example, shows that once subjects have been paid to do something that they used to do for free, they are a lot more reluctant to resume doing it for free. This is certainly a risk with TPF grants. You did not address that point. And I am sorry I don't have a citation here, I'll try to find it.

There could also be a demotivating factor for people who do not get grants. 

Again, I am not an expert on the subject, but it might be worth investigating what's the most efficient way to help Perl development.

**mirod.myopenid.com, on 2010-07-02 09:38, said:**  
While I am thinking about it, and to be a little constructive here ;-) an other idea: why not have TPF sign agreements with companies where a developer would work part time on Perl development, with the company and TPF paying each half of their salary for that portion of their time. This way the company gets exposure, the developer official time for working on the project, and their usual salary, TPF and the Perl community get the code, plus the fact that the company has to admit to using perl ;-)

**Dave Rolsky, on 2010-07-02 09:42, said:**  
@mirod: You seem to think the burden of proof is mine at this point, and I disagree. The studies you cite are interesting, but they are hardly conclusive. It's also not clear that they apply to TPF grants.

So until that's established, I think we're both at the hypothesis stage. One hypothesis (yours?) is that these studies on motivation clearly demonstrate that TPF grants are de-motivational, and that the grants clearly match what the studies looked at. In effect, this hypothesis says that the grants are _solely about money, and money is always de-motivational_.

My hypothesis is that the grants don't match the studies, because the grants aren't only about money, and therefore _we cannot conclude that they are de-motivational_.

Also, if you read the paper rjbs linked, you'll see that these studies are not clearly as clear cut as you assert. In the introduction, the paper says "The studies show that the effects of incentives are mixed and complicated."

**Casey West, on 2010-07-02 09:57, said:**  
@Dave, thanks for responding.

On the topic of Gabor's proposal my firm stance is that it's a major distraction for TPF. We ought to focus on what we do best: produce software people want to use. That is our best marketing strategy and, history shows, has produced desired results. Keep the most important thing the most important thing. Focus.

As for development grants, I suppose they fall within the focus I just described. Given current estimates of 75% failed grants I'd say the ability to motivate recipients with money hasn't been cultivated just yet. If we're going to continue development grants I'd suggest paying grant managers, too, on success. 25% of grant payout? From my observation Ricardo seems to be a very good Grant Manager and I think paying him would be worthwhile. Since money is inherently involved maybe we can motivate with money after all. Software project managers are resources we have in the Perl community.

**rjbs, on 2010-07-02 10:24, said:**  
@Casey Yeah, I agree that there are definitely tasks for which paying people seems counterproductive. Staffing a booth, for one. If we start making that a paid gig, it will never stop being one, and you won't get the people most interested in doing the work. There are a bunch of other tasks that would suffer from that problem.

I don't think it's everything, though. Paying someone to write the Moose manual (for example) is a good use of grant money. It was paying for work that was clearly of value, clearly not a lot of fun, and had a limited set of potential workers. Moose was a highly-valued tool with a growing market share, but its documentation was lacking. A lot of people wanted more documentation, but the experts were not enthused by the idea of writing a lot of documentation that they didn't need. TPF saw a need, saw someone qualified to fill it, and helped him by giving him the motivation that he promised would help.

I think this is why code-writing grants for already-established codebases are a much better idea than ones for new products. It's also not demotivating, I would guess, for other programmers because they can see that the product being worked on already has a strong following and the community is choosing to fund work on it that might not otherwise get done, and has a viable expert who is able but not necessarily eager.

On the other hand, if someone wants funding to write a new CGI.pm replacement, he is asking for pay to compete in an open market where he currently has no share. Well, plenty of other people are trying to do the same thing, so there is a much stronger case for saying, "No, the market will win." The more that the funded work resembles work that is being done by others, for free, on competing or identical projects, the worse an idea I think it probably is.

Finally, going back to the academic papers on the subject, another big theme is the replacement of intrinsic with extrinsic motivation. What we're talking about is people who are already intrinsically motivated saying, "At this point, I believe I would benefit from external motivation." This is very different from what the studies are looking at, and I think it's a reasonable proposition for people to make. How do you tell that someone is already intrinsically motivated (assuming we think that has value to begin with, here)? Well, being an active part of a successful project that was developed and given away for free is a good indicator.

**rjbs, on 2010-07-02 10:26, said:**  
Our comments crossed in flight. As for paying grant managers, I don't think it's a good idea. My experience is that the work required from a grant manager is pretty rote and boring. If I have been more successful-seeming than most, it's because of luck in those grants assigned to me. All I do as a grant manager is ask for updates and then relay them to the foundation blog. Getting paid would make me think about sticking around even when I want to quit, and I don't think that would be a good thing.

**Michael Peters, on 2010-07-02 10:46, said:**  
I'd just like to chime in as another grant recipient who found the grant very motivational. I was given a grant to improve Smolder (a project I started) in ways that lots of people asked for but that I didn't need personally or professionally. And I found it motivational for all the reasons that RJBS and Dave mentioned: It was a public promise with public scrutiny; It was donated money that should be used wisely; 

And another reason I haven't seen yet: It let me justify the extra time to my wife. The work was kind of boring (which was why no one else had stepped up to do it yet). Every project has boring work that no one wants to do. Having a way to get motivated about boring work is a good thing and I don't think any project should wither and die just because there's some boring work to do.

**brian d foy, on 2010-07-02 13:08, said:**  
On the individual level, grants motivate in different ways. Anecdotal evidence isn't that useful here. However, I've kept track of every grant that TPF was ever awarded. Although the success rate is decent now, most grants have been abandoned, and historically have been failures. In simple terms, as many people have said in many places, turning something that was play into work changes the game. Not only does it turn stuff into work, but often at pitiful wages.

When you look at most of the grant proposals nowadays, you see fringe projects of dubious value, _even if they succeed_. In general, I don't see the people who can do the best work to the best benefit of the Perl community applying for grants. Indeed, I think the grant proposals have become a black eye for Perl as other people see them as the best things we could come up with.

However, none of this matters for any particular grant. I've long advocated that grants be forced on people rather than applied for. TPF finds the right people, convinces them to take a grant (which might take a long time), and funds the worthy projects. That would work much better than the speculative ideas that people want TPF to bless before they even start coding.

**brian d foy, on 2010-07-02 13:29, said:**  
Ricardo responds too quickly to Casey's comments without thinking through how Casey, who most all of us respect, might be right. Indeed, most of the comments here go off track by talking about people who received grants. That's not the whole story, and I think Ricardo, perhaps in the heat of the moment, uses an appeal to emotion to shoot down an argument he hasn't really considered.

As I've mentioned elsewhere (in many places I think), the problem with creating an organization, giving it a name, and putting people in charge is that people start to push off responsibility to the organization and wait for its approval and blessing before they start work. This isn't just a problem with TPF. It's intrinsic to having something with a name and people with titles.

In that sense, the TPF grant process has an incredible power (although only perceived and forced on it by the public), to kill projects merely by doing nothing. Without the blessing, people tend to not act. Gabor and I have talked about this quite a bit. The problem is that people expect TPF to be in charge, and no one in TPF is emphasizing that they aren't in charge. That creates a motivational swamp of indecision and inaction. Even is this thread, mirod brings up "Why doesn't TPF...".

Look at most of the recent grant proposals. How many of those projects went forward anyway? Very few. The people who did work really would have done it anyway, although maybe at a slower pace. Dave, Ricardo, and Michael did work because they already do a lot of work. They most likely would have worked on projects despite what TPF said because that's the sort of people they are. They don't have anything to fear from TPF because they know that they can do anything they want and nobody can tell them "no". The p5p and Perl 6 developers get this, which is why those grants work.

However, Casey isn't talking about those sorts of people. I talk to a lot of people in the Perl community, and I hear many people tell me they are waiting on TPF. They keep saying that despite me telling them they don't need anyone's permission. They don't listen to the advice, they get discouraged, and nothing happens.

So, curiously, in a group of people who probably think of themselves as Dilbert, as a group they tend to work very hard to ensure that they live in Dilbert's world.

**zby, on 2010-07-02 14:31, said:**  
I don't have anything to cite here - but I believe that this demotivational effect relies on how the situation is framed - that's why I would like the grants to be formulated not as 'pay' for work - but rather 'reimbursement of costs of living for a period of your life you donate to the project' or something.

**gizmomathboy, on 2010-07-02 14:49, said:**  
What if the structure of grants change to enable people to go someplace to write code or promote Perl in non-Perlish areas?

By that I mean, get people to hackathons or conferences?

That might not interfere with the motivations just the increased productivity that can come from face to face communication with folks.

The TPF can then rethink giving grants for code prodution then.

Giving grants for documentation might still have value and need though.

**:m), on 2010-07-03 00:28, said:**  
As long as grants go to people who already have contributed huge amounts of time voluntarily I would not be de-motivated standing with them at a booth. In contrary!

You just can't pay one person for everything and let the other do everything for free.

And the paid person needs to show some ethics. By taking responsibility, doing the hard, silly, boring work, being the first-to-come and last-to-leave.