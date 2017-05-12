from katana.sdk import Service


def dumy(action):
    id = action.get_param('id').get_value()

    # read paremter
    action.set_entity({
    	'id': id,
    })
    return action


if __name__ == '__main__':
    service = Service()
    service.action('dummy', dummy)
    service.run()