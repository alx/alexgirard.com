---
type: training
title: "Agentic AI Training"
description: "Hands-on agentic AI training: practical workshops, live demos, pipelines that run themselves overnight. Toulouse, in-house and remote."
draft: false
params:
  hero:
    title: "Agentic AI<br>training"
    lead: "Hands-on workshops, live demos,<br>pipelines that run themselves overnight."
    sub: "Toulouse · in-house · remote"
    ctaPrimary: "Book the scoping call"
    ctaSecondary: "See the modules"
    latestTitle: "What we will actually build"
    latestItems:
      - strong: "Build your agents"
        text: "with the LLM of your choice, on your data."
      - strong: "Live demos"
        text: "no screenshots: the code runs live."
      - strong: "Measure reliability"
        text: "metrics before you automate, never after."
      - strong: "Automate safely"
        text: "cron, monitoring, alerts: it runs at night, without you."
  agentisation:
    kicker: "The concrete piece"
    title: "AI agents in your pipeline"
    lead: "A <strong>pi.dev agent</strong> (the open-source agent tooling I use daily) deployed in your environment, wired to your data, running on its own at night."
    pointsTitle: "What I set up at your place"
    points:
      - "The pi.dev harness deployed on your machines — Windows and Linux alike."
      - "The LLM of your choice: a hosted model via api.girard-davila.net, or your own deepinfra key."
      - "Safe automation: cron, monitoring, alerts, metrics before anything ships."
    proofSummary: "Deployment proof: Windows computer + deepseek-v4.1-flash (already deployed at a client)"
    proofHeading: "The step-by-step deployment"
    proofIntro: "Create your account at [api.girard-davila.net](https://api.girard-davila.net/api/llm/sso/key/generate) to get your API key (GitHub sign-in), then connect pi in a few commands:"
    proofSteps:
      - "curl -fsSL https://pi.dev/install.sh | sh"
      - "pi install git:github.com/alx/pi-provider-gd"
      - "pi  →  /login gd   (GitHub sign-in at api.girard-davila.net — key stored automatically)"
      - "/model gd   → pick a model, e.g. gd/Qwen3.8-27B-i1-IQ4_XS-GGUF-Smaller or gd/deepseek-v4.1-flash"
      - "say “test” — the agent replies"
    proofMermaid: |-
      flowchart TD
        A["curl -fsSL https://pi.dev/install.sh | sh"] --> B["pi install git:github.com/alx/pi-provider-gd"]
        B --> C["/login gd — GitHub sign-in (api.girard-davila.net)"]
        C --> D["/model gd — pick a model"]
        D --> E["say “test” — the agent replies"]
    accessTitle: "For your agents, on the model side"
    accessText: "Two options: your own deepinfra key (bring-your-own), or an api.girard-davila.net account — key generated in a few clicks, credits included in beta. One-command connect via pi-provider-gd."
    cta: "Book the scoping call"
  modules:
    title: "Modules"
    intro: "Five training modules, each standalone or combinable into a path. Every module starts from a live demo, not a slideshow."
    cards:
      - name: "M1 · AI agent fundamentals"
        badge: "½ day"
        desc: "What actually changes with agents? A shared foundation for the whole team, in decision + team mode."
      - name: "M2 · Automating your daily work"
        badge: "1 day"
        desc: "From demo to production script: your real tasks, automated at your place, not the trainer's."
      - name: "M3 · Autonomous pipeline: ralph, beads & sub-agents"
        badge: "2 days"
        desc: "A development loop that works by itself: issue base (beads), autonomous iteration (ralph), sub-agents that check each other."
      - name: "M4 · Local LLMs & image generation on GPU"
        badge: "1–2 days"
        desc: "llama.cpp on a 12–24 GB card, local OpenAI-compatible API service, Stable Diffusion with control (LoRA, post-processing)."
      - name: "M5 · Agentization audit & roadmap"
        badge: "2–3 days on-site"
        desc: "Map your workflows, score what can be automated now, quantify the gain, produce a roadmap leadership can execute without me."
    link: "See the full module details →"
  contact:
    kicker: "Point of contact"
    title: "Let's talk about your training."
    para: "Describe your team and your goal in two lines. You get a free 30-minute scoping call within 48 business hours."
    sub: "One human on the other end, no qualification bot. If I'm not the right person, I'll tell you and point you somewhere."
    successTitle: "Message sent."
    successText: "I read everything myself — reply from a human within 48 business hours."
    labels:
      name: "Your name"
      namePlaceholder: "First Last"
      email: "Work email"
      emailPlaceholder: "you@company.com"
      message: "Your context, in two lines"
      messagePlaceholder: "Team (size, industry), what exists today, the decision to be made."
    submit: "Send →"
    hint: "Goes straight to a human. No bot, no newsletter."
---
