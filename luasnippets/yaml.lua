local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet

-- plain text
local function p(trig, text, opts)
    return s(trig, fmt(text, {}, opts))
end


return {
    p("docker-compose", [[
version: "3.8"

services:
	app:
		image: path/to/tag
		build: .
		environment:
			VAR1: value1
			VAR2: value2
		volumes:
			- ${PWD}:/app
		ports:
			- "8000:8000"
		working_dir: /app/src
		command: uvicorn app.main:app --reload --host 0.0.0.0
		
	rabbit:
		image: rabbitmq:latest
		container_name: rabbit
		environment:
			RABBITMQ_DEFAULT_VHOST: vhost
		ports:
			- 5672:5672
		volumes:
			- /host/full/path:/container/path
]], { delimiters = "<>" })

}
