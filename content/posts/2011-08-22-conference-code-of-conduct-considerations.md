---
title: Conference Code of Conduct Considerations
author: Dave Rolsky
type: post
date: 2011-08-22T13:50:54+00:00
url: /2011/08/22/conference-code-of-conduct-considerations/
---
A [recent discussion on the YAPC::NA blog][1] reminded me of the importance of having a code of conduct for conferences. I [wrote about this previously][2] in the context of creating a policy for my animal rights group. Now that the issue's come up with YAPC, I'm thinking about what the ideal policy for a conference should look like.

I do sympathize with people who don't like these policies, and think they should be as short as possible. Isn't it obvious that some things are unacceptable? Shouldn't we be able to "just" act like adults and treat each other with respect? Do we really need all these rules stated up front?

A code of conduct is not written for the vast majority of attendees, who act reasonably and treat each other with respect. They're written for two groups of people. First, the code exists for people whose idea of what's acceptable falls outside of the community standards. Having a policy in place may help them recognize that certain behaviors aren't okay. After all, most of us wouldn't fill our slide decks with sexual images, because that's obviously a bad idea, but it still happens. Second, the policy is for people who are concerned that they may be victims of harassment at a conference. Having a code of conduct makes it very clear that the conference organizers take this issue seriously. It also gives them clear guidelines on reporting incidents.

Calling it a "code of conduct" may be a bit misleading. We need more than just a list of expectations. We also need guidelines for reporting harassment and a policy for dealing with people who fail to follow the code of conduct. This is important because it helps reassure attendees who may fear harassment that there is a mechanism for dealing with it. A code of conduct all by itself, absent a reporting procedure, is like having laws without a way to report infractions to the police.

The Geek Feminism Wiki has an [example anti-harassment policy][3] that makes some important points. I really like the template they provide for internal use with conference staff that gives some specific information on how to handle issues that arise.

One of the things I dislike about it is the description of harassment, which says "Harassment includes offensive verbal comments". The problem is the use of word "offensive". This seems innocuous at first, but it's awfully subjective. There's really no consensus on what constitutes "offensive", other than whether or not a particular person is offended. A good example might be using the word "chick" to refer to a woman. I know women who find this offensive, and others who don't.

A closely related problem is that this example policy doesn't encourage any sort of mediation. In many cases, both the offended person and the offender have legitimate arguments. An ideal policy would encourage the two people to discuss the issue together and resolve the issue amicably. In many cases, it may be sufficient for the offender to say something like "I'm sorry, I didn't realize that saying X would bother you, I'll be more mindful of your concerns in the future".

(Note that the issue here _isn't_ whether the word "chick" is acceptable. The important point is that both parties may have legitimate claims, and the ideal outcome is for both parties to agree on how they can get along in the future, so they both can enjoy the rest of the conference.)

In the YAPC::NA blog discussion, one issue mentioned was not wanting to have a list of specific topics or words which are forbidden. A list of words is a red herring. I've never seen such a policy. The Geek Feminism Wiki policy does list specific issues such as comments related to gender, race, sexual orientation, etc. The concern I've heard about this sort of phrasing is that someone will do something not specifically on the list and then try to be a rules lawyer when they're called on it.

One way to deal with this is to start with a general "don't be an asshole" section. That's what the [YAPC::NA 2011 Code of Conduct][4] does. Then there can be a list of some specific offenses (sexual imagery in slides, harassing photography, belittling comments, inappropriate physical contact, etc. Finally, the policy can say "harassment includes, but is not limited to [list of things]".

The reason to list specific things is that not everyone agrees on what "don't be an asshole" means. Past incidents at a variety of conferences make this very clear. Listing specific past issues really can't hurt, and it could help.

Overall, I think the YAPC::NA 2011 Code of Conduct is a good start. I'd add a list of specific offenses after the opening "Reasonable Person Principle". I'd also remove the bit about recommending a restraining order. This seems somewhat out of place. None of the conference incidents I've read about have been the culmination of a long-term dispute between two people, so a restraining order isn't really relevant.

Finally, the policy needs more explicit guidelines on how to report harassment. In particular, it should includes names, phone numbers, and email addresses for key conference organizers. It may not always be obvious to a conference newbie who the organizers are, and they may not be able to find one in person.

Conferences also need an internal document like the one in the Geek Feminism Wiki. This document should be distributed to all volunteer staff at the event.

I'd like to see a standard policy adopted for all Perl events. At the very least, TPF can work with the community to create a required policy for TPF-sponsored events.

 [1]: http://blog.yapcna.org/post/9196402166/basic-civility
 [2]: /2011/01/04/creating-the-perfect-anti-harassment-policy/
 [3]: http://geekfeminism.wikia.com/wiki/Conference_anti-harassment_policy
 [4]: http://www.yapc2011.us/yn2011/conduct.html

## Comments

**Barbie, on 2011-08-23 05:06, said:**  
I've already added something to my Perl Jam book [1], which is available on GitHub [2]. I've started with the two YAPC::NA pieces, but would be interested to expand these further, particularly regarding the methods of reporting and what processes organisers should follow.

[1] <a href="http://perljam.info" rel="nofollow ugc">http://perljam.info</a>  
[2] <a href="https://github.com/barbie/perl-jam" rel="nofollow ugc">https://github.com/barbie/perl-jam</a>

**brian d foy, on 2011-08-23 11:50, said:**  
The US Army has a <a href="http://www.sexualassault.army.mil/files/r600_20_chapter7.pdf" rel="nofollow">well-defined process for dealing with sexual harassment</a> (lest some people forget, this is the root of the current code of conduct stuff). It defines it, tells people how to deal with it, and so on. I've had to go through the process a couple of times as a leader, and I received lots more training on it. The first step is always direct approach. It's not harassment until you tell someone to stop and they keep doing it.

For those with corporate jobs, talk to your HR people. They should have all the tools anyone would need to help YAPC form a good policy.

But, let's also not go down the road of having people sign a waiver to attend a conference. Once a policy is in place, people now have a way to hang the conference organizers.

I also like to point out that many of the reasons people push for these policies go back to alcohol-related incidents. If you are going to be around drunk people, you have to realize they are not in control of themselves. If you can't deal with that, don't be around drunk people.

**Dave Rolsky, on 2011-08-23 12:06, said:**  
@brian: I agree that a direct approach should be the first step. That's why one of my complaints about the Geek Feminism Wiki's example is that it makes no mention of mediation.

I do think that the reporting policy section of a YAPC code should make it explicit that conference organizers encourage a direct approach first for "minor" incidents. What's minor? I'm not sure where the line is.

If the complainant is uncomfortable doing this (which is entirely legitimate) then the next step should be asking a conference organizer to act as a mediator in talking to the offender.

Your point about drunk people is interesting. To what degree are people responsible for their behavior when drunk? Clearly they exercise less self-control. But if you know that you act inappropriately when drunk, do you have a responsibility to not get drunk with strangers? If someone gets drunk and violates the code of conduct, then what should the conference organizers do? We can ask that person to simply refrain from drinking to excess. If they can't do that, then I think it's entirely legitimate to eject them from the conference.

I don't want to blame the victim because they went to an after-hours party at the conference and were sexually assaulted. It seems reasonable to expect that you can attend an event with alcohol and not be assaulted, doesn't it?

Some people might suggest that the conference try to control drinking, but that seems quixotic at best, especially since a lot of drinking occurs in people's hotel/dorm rooms after official conference events.

FWIW, I've seen a lot of Perl people get quite drunk at conferences, but I've never seen that lead to an unpleasant incident.

**brian d foy, on 2011-08-25 11:47, said:**  
I think that Perl conferences don't have the problem that the agitators are worried about. We talked about this quite a bit at YAPC::EU with people who have been to lots of non-Perl events. 

As for getting drunk, I'm not telling people not to drink. I'm telling people who don't want to be around uninhibited and possibly temporarily out of control people not to be around drunk people. People are responsible for their own behavior always, including putting themselves in a situation where other people might harm them. I don't think it's reasonable at all to expect that nothing bad will happen to you when people around you are drinking. And, don't hang out in hotel rooms with lots of drunks expecting to come out unscathed. Do your socializing in public where there is some social control.

Indeed, I think that's the problem: people don't think anything bad should ever happen to them and don't take responsibility for ensuring that it doesn't. They put themselves in risky situations and are surprised when they incur the risk. You should be able to do all sorts or things, like swimming in the ocean without having your legs bitten off. "Should" doesn't matter though, and many people need to start paying attention to what will probably happen instead of what they hope will happen.

This is irregardless of any policy. Policies, like the police, only respond once there is a victim with damages. Work at not being a victim in the first place, the area before anyone has a chance to respond to trouble.

**Noirin, on 2011-09-06 13:26, said:**  
@Brian  
I haven't been to a Perl conference, but I \*have\* heard of problems at them. 

And as for "They put themselves in risky situations and are surprised when they incur the risk"-my friends and I have been harassed at parties, yes, official and unofficial. But we've also been harassed (and assaulted) on the expo hall floor, in the hallways, and in other "public"/alcohol-free places. Should we stop coming to conferences altogether? Stay home and lose out on the career opportunities, the fun of speaking, the chance to catch up with friends from around the world? 

I don't think that's fair. 

@Dave  
I think mediation is a great idea in some cases, but I also think it's important to remember (and probably document somewhere!) that mediation doesn't mean "sitting people down and telling them to talk it through" :-) 

A lot of the pushback I've heard from conferences, particular volunteer-run ones, is "we don't have any staff, or expertise". I'd love to see a mediators guide that could be handed out to help people understand when it's appropriate and how best to approach it.

**Dave Rolsky, on 2011-09-06 13:38, said:**  
@noirin: When I say mediation I mean a telling them to talk it through \_with a mediator present\_. In order to do that effectively, you have to find some people willing to be mediators in advance. They can be conference volunteers, or attendees the conference organizers trust to do this sort of thing.

Telling them to talk it through without another person present would be a very bad idea, but that doesn't fit any definition of mediation with which I'm familiar ;)

Mediation is appropriate for personal interaction problems where the issue is communication. If the incident is about physical contact, stalking, inappropriate photography, etc. then mediation is probably off the table, though I think the conference organizers still need to sit down with the alleged offender and hear their side of it in most cases.

The exception is a serious incident with one or more uninvolved witnesses who will support the offended parties version of events.

**Mike Warren, on 2012-01-18 02:13, said:**  
It is good that there are conferences like this. It would be a warning to those who will not follow the code of conduct.