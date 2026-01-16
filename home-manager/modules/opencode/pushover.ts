import type { Plugin } from "@opencode-ai/plugin"
import { execFile } from "node:child_process"
import { hostname } from "node:os"

type LogExtra = Record<string, unknown>

type LogLevel = "debug" | "info" | "warn" | "error"

type NotifyPayload = {
  message: string
}

export const PushoverNotify: Plugin = async ({ client }) => {
  const apiToken = process.env.PUSHOVER_TOKEN
  const apiUser = process.env.PUSHOVER_USER
  const log = (level: LogLevel, message: string, extra: LogExtra = {}) => {
    void client.app.log({
      service: "pushover",
      level,
      message,
      extra,
    })
  }

  log("debug", "Pushover env status", {
    hasToken: Boolean(apiToken),
    hasUser: Boolean(apiUser),
  })

  if (!apiToken || !apiUser) {
    log("warn", "Pushover env missing", {
      hasToken: Boolean(apiToken),
      hasUser: Boolean(apiUser),
    })
    return {}
  }

  const shouldNotify = async () => {
    if (!process.env.TMUX || !process.env.TMUX_PANE) {
      log("debug", "Skipping notify outside tmux")
      return false
    }

    const flags = await new Promise<string>((resolve) => {
      execFile(
        "tmux",
        ["display-message", "-p", "-t", process.env.TMUX_PANE ?? "", "#{client_flags}"],
        { timeout: 1000 },
        (error, stdout) => {
          if (error) {
            log("warn", "Failed to read tmux client flags", {
              error: String(error),
            })
            resolve("")
            return
          }

          resolve(stdout.trim())
        }
      )
    })

    if (!flags) {
      log("debug", "No tmux flags returned")
      return false
    }

    const focused = flags.split(",").includes("focused")
    log("debug", "Tmux focus status", { flags, focused })
    return !focused
  }

  const notify = ({ message }: NotifyPayload) => {
    void (async () => {
      if (!(await shouldNotify())) {
        return
      }

      const body = new URLSearchParams({
        token: apiToken,
        user: apiUser,
        title: "opencode",
        message,
      })
      const serverHost = hostname()
      body.set("url", `http://${serverHost}:4096`)
      body.set("url_title", "Open opencode")

      const controller = new AbortController()
      const timeout = setTimeout(() => controller.abort(), 3000)

      try {
        const response = await fetch("https://api.pushover.net/1/messages.json", {
          method: "POST",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body,
          signal: controller.signal,
        })

        if (!response.ok) {
          const responseBody = await response.text()
          log("error", "Pushover request failed", {
            status: response.status,
            body: responseBody,
          })
        }
      } catch (error) {
        log("error", "Pushover request error", {
          error: String(error),
        })
      } finally {
        clearTimeout(timeout)
      }
    })()
  }

  return {
    event: async ({ event }) => {
      if (!(["session.idle", "permission.replied"] as const).includes(event.type)) {
        return
      }

      log("debug", "Pushover event received", {
        type: event.type,
      })

      const isPermission = event.type.startsWith("permission.")
      const toolName = event.tool
        ?? event.permission?.tool
        ?? event.request?.tool
        ?? event.data?.tool
        ?? event.data?.permission?.tool
        ?? event.data?.request?.tool
      const command = event.command
        ?? event.args?.command
        ?? event.data?.command
        ?? event.data?.args?.command

      const message = isPermission
        ? `Permission request: ${toolName ?? "unknown"}${command ? ` (${command})` : ""}`
        : `Event: ${event.type}`

      notify({ message })
    },
  }
}
